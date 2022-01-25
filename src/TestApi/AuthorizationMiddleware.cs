using System.Net;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;

namespace TestApi
{
    public class AuthorizationMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IOptions<Authentication> _authOptions;

        public AuthorizationMiddleware(RequestDelegate next, IOptions<Authentication> authOptions)
        {
            _next = next;
            _authOptions = authOptions;
        }

        public async Task InvokeAsync(HttpContext httpContext)
        {
            var clientToken = httpContext.Request.Headers["Authorization"];
            if ($"Bearer {_authOptions.Value.AccessToken}" == clientToken)
            {
                await _next(httpContext);
            }
            else
            {
                var re = httpContext.Response;
                re.StatusCode = (int) HttpStatusCode.Unauthorized;
            }
        }
    }
}
