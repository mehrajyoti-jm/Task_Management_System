using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TaskManagementAPI.Data;

namespace TaskManagementAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")] // -> /api/notifications
    [Authorize]
    public class NotificationsController : ControllerBase
    {
        private readonly AppDbContext _db;

        public NotificationsController(AppDbContext db)
        {
            _db = db;
        }

        private int CurrentUserId => int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

        // GET /api/notifications -> the logged-in user's notifications
        [HttpGet]
        public async Task<IActionResult> GetMyNotifications()
        {
            var notifications = await _db.Notifications
                .Where(n => n.UserId == CurrentUserId)
                .OrderByDescending(n => n.CreatedAt)
                .ToListAsync();

            return Ok(notifications);
        }

        // PUT /api/notifications/5/read -> mark a notification as read
        [HttpPut("{id}/read")]
        public async Task<IActionResult> MarkAsRead(int id)
        {
            var notification = await _db.Notifications.FindAsync(id);
            if (notification == null || notification.UserId != CurrentUserId)
                return NotFound();

            notification.IsRead = true;
            await _db.SaveChangesAsync();

            return Ok(notification);
        }
    }
}
