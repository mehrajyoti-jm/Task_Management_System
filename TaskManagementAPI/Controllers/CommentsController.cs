using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TaskManagementAPI.Data;
using TaskManagementAPI.DTOs;
using TaskManagementAPI.Models;

namespace TaskManagementAPI.Controllers
{
    [ApiController]
    [Route("api/tasks/{taskId}/[controller]")] // -> /api/tasks/5/comments
    [Authorize]
    public class CommentsController : ControllerBase
    {
        private readonly AppDbContext _db;

        public CommentsController(AppDbContext db)
        {
            _db = db;
        }

        private int CurrentUserId => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

        // GET /api/tasks/5/comments
        [HttpGet]
        public async Task<IActionResult> GetComments(int taskId)
        {
            var comments = await _db.Comments
                .Include(c => c.User)
                .Where(c => c.TaskItemId == taskId)
                .OrderBy(c => c.CreatedAt)
                .ToListAsync();

            return Ok(comments.Select(c => new
            {
                c.Id,
                c.Text,
                c.CreatedAt,
                User = c.User == null ? null : new { c.User.Id, c.User.FullName }
            }));
        }

        // POST /api/tasks/5/comments
        [HttpPost]
        public async Task<IActionResult> AddComment(int taskId, CreateCommentDto dto)
        {
            var taskExists = await _db.Tasks.AnyAsync(t => t.Id == taskId);
            if (!taskExists)
                return NotFound(new { message = "Task not found." });

            var comment = new Comment
            {
                TaskItemId = taskId,
                UserId = CurrentUserId,
                Text = dto.Text
            };

            _db.Comments.Add(comment);
            await _db.SaveChangesAsync();

            return Ok(comment);
        }
    }
}
