using ClinicaEsteticaWeb.Services;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.AddJsonFile("appsettings.local.json", optional: true, reloadOnChange: false);
builder.Services.AddControllersWithViews();
builder.Services.AddSingleton<Db>();
builder.Services.AddSingleton<SecurityService>();
builder.Services.AddSingleton<WebSessionService>();
builder.Services.AddSingleton<SeedService>();
builder.Services.AddHttpContextAccessor();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
    options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
    options.Cookie.SameSite = SameSiteMode.Strict;
});
var app = builder.Build();
using (var scope = app.Services.CreateScope()) { scope.ServiceProvider.GetRequiredService<SeedService>().Run(); }
if (!app.Environment.IsDevelopment()) app.UseExceptionHandler("/Home/Error");
app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseSession();
app.UseMiddleware<WebSessionMiddleware>();
app.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}");
app.Run();
