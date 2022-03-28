using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace TestApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;
        private readonly IOptions<Authentication> _authOptions;

        public WeatherForecastController(ILogger<WeatherForecastController> logger, IOptions<Authentication> authOptions)
        {
            _logger = logger;
            _authOptions = authOptions;
        }

        [HttpGet]
        public IEnumerable<WeatherForecast> Get()
        {
            var rng = new Random();
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateTime.Now.AddDays(index),
                TemperatureC = rng.Next(-20, 55),
                Summary = Summaries[rng.Next(Summaries.Length)]
            })
            .ToArray();
        }

        [HttpGet("version")]
        public string Version()
        {
            return GetType().Assembly.GetName().Version?.ToString();
        }

        [HttpGet("secret")]
        public string Secret()
        {
            return _authOptions?.Value?.AccessToken ?? "KV not accessed yet";
        }
    }
}
