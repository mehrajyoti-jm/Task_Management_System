namespace TaskManagementAPI.Models
{
    // This class represents a Team. Admins create teams and assign users to them.
    public class Team
    {
        public int Id { get; set; }

        public string Name { get; set; } = string.Empty;

        // Every team has one Manager (the person who assigns tasks to team members)
        public int? ManagerId { get; set; }
        public User? Manager { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // A team has many members (Users)
        public List<User> Members { get; set; } = new();
    }
}
