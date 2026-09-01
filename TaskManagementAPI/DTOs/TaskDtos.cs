namespace TaskManagementAPI.DTOs
{
    public class CreateTaskDto
    {
        public string Title { get; set; } = string.Empty;
        public string Description { get; set; } = string.Empty;
        public string Priority { get; set; } = "Medium";
        public DateTime? Deadline { get; set; }
        public int AssignedToId { get; set; }
    }

    public class UpdateTaskStatusDto
    {
        // Must be one of: "To Do", "In Progress", "Done"
        public string Status { get; set; } = "To Do";
    }

    public class CreateTeamDto
    {
        public string Name { get; set; } = string.Empty;
        public int? ManagerId { get; set; }
    }

    public class AssignUserToTeamDto
    {
        public int UserId { get; set; }
        public int TeamId { get; set; }
    }

    public class CreateCommentDto
    {
        public string Text { get; set; } = string.Empty;
    }
}
