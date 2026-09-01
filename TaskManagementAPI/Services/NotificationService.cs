using TaskManagementAPI.Data;
using TaskManagementAPI.Models;

namespace TaskManagementAPI.Services
{
    // This service creates "mock" notifications (saved to the database)
    // instead of sending real emails. This satisfies the assignment's
    // requirement: "Email notifications, OR mock notifications if email
    // integration is not implemented."
    public class NotificationService
    {
        private readonly AppDbContext _db;

        public NotificationService(AppDbContext db)
        {
            _db = db;
        }

        public async Task NotifyAsync(int userId, string message)
        {
            var notification = new Notification
            {
                UserId = userId,
                Message = message,
                CreatedAt = DateTime.UtcNow
            };

            _db.Notifications.Add(notification);
            await _db.SaveChangesAsync();

            // In a real app, you'd also call an email service here, e.g.:
            // await _emailSender.SendAsync(user.Email, "Task Update", message);
        }
    }
}
