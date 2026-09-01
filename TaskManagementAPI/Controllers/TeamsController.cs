using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using TaskManagementAPI.Data;
using TaskManagementAPI.DTOs;
using TaskManagementAPI.Models;

namespace TaskManagementAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")] // -> /api/teams
    [Authorize] // Must be logged in for everything in this controller
    public class TeamsController : ControllerBase
    {
        private readonly AppDbContext _db;

        public TeamsController(AppDbContext db)
        {
            _db = db;
        }

        // GET /api/teams  -> anyone logged in can view teams
        [HttpGet]
        public async Task<IActionResult> GetTeams()
        {
            var teams = await _db.Teams
                .Include(t => t.Manager)
                .Include(t => t.Members)
                .ToListAsync();

            return Ok(teams.Select(t => new
            {
                t.Id,
                t.Name,
                Manager = t.Manager == null ? null : new { t.Manager.Id, t.Manager.FullName },
                Members = t.Members.Select(m => new { m.Id, m.FullName, m.Role })
            }));
        }

        // POST /api/teams -> only Admin can create teams
        [HttpPost]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> CreateTeam(CreateTeamDto dto)
        {
            var team = new Team
            {
                Name = dto.Name,
                ManagerId = dto.ManagerId
            };

            _db.Teams.Add(team);
            await _db.SaveChangesAsync();

            return Ok(team);
        }

        // POST /api/teams/assign-user -> Admin assigns a user to a team
        [HttpPost("assign-user")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> AssignUserToTeam(AssignUserToTeamDto dto)
        {
            var user = await _db.Users.FindAsync(dto.UserId);
            var team = await _db.Teams.FindAsync(dto.TeamId);

            if (user == null || team == null)
                return NotFound(new { message = "User or Team not found." });

            user.TeamId = team.Id;
            await _db.SaveChangesAsync();

            return Ok(new { message = $"{user.FullName} was added to team {team.Name}." });
        }

        // GET /api/teams/users -> get all users (helper endpoint, used to populate dropdowns in UI)
        [HttpGet("users")]
        public async Task<IActionResult> GetAllUsers()
        {
            var users = await _db.Users
                .Select(u => new { u.Id, u.FullName, u.Email, u.Role, u.TeamId })
                .ToListAsync();

            return Ok(users);
        }
    }
}
