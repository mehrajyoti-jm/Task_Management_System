using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TaskManagementAPI.Data;
using TaskManagementAPI.DTOs;
using TaskManagementAPI.Models;
using TaskManagementAPI.Services;

namespace TaskManagementAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")] // -> /api/task
    [Authorize] // Must be logged in
    public class TasksController : ControllerBase
    {
        private readonly AppDbContext _db;
        private readonly NotificationService _notificationService;

        public TasksController(AppDbContext db, NotificationService notificationService)
        {
            _db = db;
            _notificationService = notificationService;
        }

        // Small helper: read the logged-in user's Id from the JWT token
        private int CurrentUserId => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);
        private string CurrentUserRole => User.FindFirstValue(ClaimTypes.Role)!;

        // GET /api/tasks?status=&priority=&deadline=
        // Users see only their own tasks. Admin/Manager see all tasks.
        [HttpGet]
        public async Task<IActionResult> GetTasks(
            [FromQuery] string? status,
            [FromQuery] string? priority,
            [FromQuery] DateTime? deadline)
        {
            IQueryable<TaskItem> query = _db.Tasks
                .Include(t => t.AssignedTo)
                .Include(t => t.AssignedBy);

            // Role-based filtering: a normal "User" can only see tasks assigned to them
            if (CurrentUserRole == "User")
            {
                query = query.Where(t => t.AssignedToId == CurrentUserId);
            }

            // Optional filters (Dashboard requirement: filter by deadline, status, priority)
            if (!string.IsNullOrEmpty(status))
                query = query.Where(t => t.Status == status);

            if (!string.IsNullOrEmpty(priority))
                query = query.Where(t => t.Priority == priority);

            if (deadline.HasValue)
                query = query.Where(t => t.Deadline != null && t.Deadline.Value.Date == deadline.Value.Date);

            var tasks = await query.OrderByDescending(t => t.CreatedAt).ToListAsync();

            return Ok(tasks.Select(t => new
            {
                t.Id,
                t.Title,
                t.Description,
                t.Status,
                t.Priority,
                t.Deadline,
                t.CreatedAt,
                AssignedTo = t.AssignedTo == null ? null : new { t.AssignedTo.Id, t.AssignedTo.FullName },
                AssignedBy = t.AssignedBy == null ? null : new { t.AssignedBy.Id, t.AssignedBy.FullName }
            }));
        }

        // POST /api/tasks -> only Admin or Manager can create/assign tasks
        [HttpPost]
        [Authorize(Roles = "Admin,Manager")]
        public async Task<IActionResult> CreateTask(CreateTaskDto dto)
        {
            var assignedUser = await _db.Users.FindAsync(dto.AssignedToId);
            if (assignedUser == null)
                return NotFound(new { message = "The user you're assigning this task to was not found." });

            var task = new TaskItem
            {
                Title = dto.Title,
                Description = dto.Description,
                Priority = dto.Priority,
                Deadline = dto.Deadline,
                AssignedToId = dto.AssignedToId,
                AssignedById = CurrentUserId,
                Status = "To Do"
            };

            _db.Tasks.Add(task);
            await _db.SaveChangesAsync();

            // Trigger a notification: "Task assignment" event
            await _notificationService.NotifyAsync(
                assignedUser.Id,
                $"You have been assigned a new task: \"{task.Title}\""
            );

            return Ok(task);
        }

        // PUT /api/tasks/5/status -> update task status (To Do / In Progress / Done)
        [HttpPut("{id}/status")]
        public async Task<IActionResult> UpdateStatus(int id, UpdateTaskStatusDto dto)
        {
            var allowedStatuses = new[] { "To Do", "In Progress", "Done" };
            if (!allowedStatuses.Contains(dto.Status))
                return BadRequest(new { message = "Status must be 'To Do', 'In Progress', or 'Done'." });

            var task = await _db.Tasks.FindAsync(id);
            if (task == null)
                return NotFound(new { message = "Task not found." });

            // A regular "User" can only update tasks assigned to them
            if (CurrentUserRole == "User" && task.AssignedToId != CurrentUserId)
                return Forbid();

            task.Status = dto.Status;
            await _db.SaveChangesAsync();

            // Trigger a notification: "Task status update" event -> notify whoever assigned the task
            await _notificationService.NotifyAsync(
                task.AssignedById,
                $"Task \"{task.Title}\" status was updated to \"{task.Status}\"."
            );

            return Ok(task);
        }

        // DELETE /api/tasks/5 -> only Admin or Manager can delete a task
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin,Manager")]
        public async Task<IActionResult> DeleteTask(int id)
        {
            var task = await _db.Tasks.FindAsync(id);
            if (task == null)
                return NotFound(new { message = "Task not found." });

            _db.Tasks.Remove(task);
            await _db.SaveChangesAsync();

            return Ok(new { message = "Task deleted." });
        }

        // GET /api/tasks/dashboard-summary -> counts of tasks per status (for the dashboard)
        [HttpGet("dashboard-summary")]
        public async Task<IActionResult> GetDashboardSummary()
        {
            IQueryable<TaskItem> query = _db.Tasks;

            if (CurrentUserRole == "User")
                query = query.Where(t => t.AssignedToId == CurrentUserId);

            var summary = new
            {
                ToDo = await query.CountAsync(t => t.Status == "To Do"),
                InProgress = await query.CountAsync(t => t.Status == "In Progress"),
                Done = await query.CountAsync(t => t.Status == "Done")
            };

            return Ok(summary);
        }
    }
}
