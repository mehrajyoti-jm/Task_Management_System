namespace TaskManagementAPI.Models
{
    // This class represents a single Task that is assigned to a user.
    public class TaskItem
    {
        public int Id { get; set; }

        public string Title { get; set; } = string.Empty;

        public string Description { get; set; } = string.Empty;

        // Allowed values: "To Do", "In Progress", "Done"
        public string Status { get; set; } = "To Do";

        // Allowed values: "Low", "Medium", "High"
        public string Priority { get; set; } = "Medium";

        public DateTime? Deadline { get; set; }

        // Who the task is assigned to
        public int AssignedToId { get; set; }
        public User? AssignedTo { get; set; }

        // Who created / assigned the task (Admin or Manager)
        public int AssignedById { get; set; }
        public User? AssignedBy { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // A task can have many comments
        public List<Comment> Comments { get; set; } = new();
    }
}
