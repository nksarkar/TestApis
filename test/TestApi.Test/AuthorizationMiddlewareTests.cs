using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Options;
using Moq;
using Xunit;

namespace TestApi.Test
{
    public class AuthorizationMiddlewareTests
    {
        [Fact]
        public async Task GivenClientTokenInHttpContext_WhenUnmatched_ReturnUnAuthorizedAsync()
        {
            var authentication = new Authentication()
            {
                AccessToken = "Bearer not-matched"
            };

            var options = new Mock<IOptions<Authentication>>();
            options.Setup(o => o.Value).Returns(authentication);

            var httpContext = new DefaultHttpContext();
            httpContext.Request.Headers["Authorization"] = "abc";

            RequestDelegate next = (HttpContext hc) => Task.CompletedTask;
            var middleware = new AuthorizationMiddleware(next, options.Object);
            await middleware.InvokeAsync(httpContext);
            Assert.Equal(401, httpContext.Response.StatusCode);
        }

        [Fact]
        public async Task GivenClientTokenInHttpContext_WhenMatched_ReturnSuccessfulAsync()
        {
            var authentication = new Authentication()
            {
                AccessToken = "abc"
            };

            var options = new Mock<IOptions<Authentication>>();
            options.Setup(o => o.Value).Returns(authentication);

            var httpContext = new DefaultHttpContext();
            httpContext.Request.Headers["Authorization"] = "Bearer abc";

            RequestDelegate next = (HttpContext hc) => Task.CompletedTask;
            var middleware = new AuthorizationMiddleware(next, options.Object);
            await middleware.InvokeAsync(httpContext);
            Assert.Equal(200, httpContext.Response.StatusCode);
        }
    }
}
