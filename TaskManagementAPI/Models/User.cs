namespace TaskManagementAPI.Models
{
    // This class represents a user (Admin, Manager, or User) in our system.
    public class User
    {
        public int Id { get; set; }

        public string FullName { get; set; } = string.Empty;

        public string Email { get; set; } = string.Empty;

        // We NEVER store plain text passwords. We store a hashed version.
        public string PasswordHash { get; set; } = string.Empty;

        // Role can be: "Admin", "Manager", or "User"
        public string Role { get; set; } = "User";

        // A user can belong to one team (nullable because Admins may not belong to a team)
        public int? TeamId { get; set; }
        public Team? Team { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    }
}
