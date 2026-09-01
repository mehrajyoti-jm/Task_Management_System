namespace TaskManagementAPI.Models
{
    // This class stores "mock" notifications instead of sending real emails.
    // Every time something important happens (task assigned, status changed),
    // we save a row here so the user can see it in their notification list.
    public class Notification
    {
        public int Id { get; set; }

        public int UserId { get; set; }
        public User? User { get; set; }

        public string Message { get; set; } = string.Empty;

        public bool IsRead { get; set; } = false;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
