public class MyAuthenticationMiddleware : AuthenticationMiddleware<MyAuthenticationOptions>
{
    public MyAuthenticationMiddleware(
        IMyService myService, // inject service here?? (via Startup.ConfigureServices(), services.AddTransient() )
        RequestDelegate next,
        IOptions<MyAuthenticationOptions> options,
        ILoggerFactory loggerFactory,
        UrlEncoder encoder)
        : base(next, options, loggerFactory, encoder)
    {
        _myService = myService;
    }

    private IMyService _myService { get; }

    protected override AuthenticationHandler<MyAuthenticationOptions> CreateHandler(/* inject service here somehow? */)
    {
        // pass singleton instance to scope instance?
        // use DI to resolve instead of `new` instance here?
        return new MyAuthenticationHandler(_myService);
    }
}

public class MyAuthenticationOptions : AuthenticationOptions
{
    public MyAuthenticationOptions(/* inject here not allowed, empty cstr required. */)
    {
        // injection not possible
    }
}

public class PCSAuthenticationHandler : AuthenticationHandler<MyAuthenticationOptions>
{
    public MyAuthenticationHandler(
        IMyService myService) // inject here somehow??
    {
        _myService = myService;
    }

    private IMyService _myService { get; }

    protected override async Task<AuthenticateResult> HandleAuthenticateAsync(/* or inject here maybe? */)
    {
        await Task.Yield();

        // need _myService.MyAwesomeFunction() here...

        return AuthenticateResult.Fail("Dependency Injection");
    }
}