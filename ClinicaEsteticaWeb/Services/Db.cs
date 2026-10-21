using MySqlConnector;
namespace ClinicaEsteticaWeb.Services;
public class Db { private readonly Config _cfg; public Db(IConfiguration c){_cfg=new Config(c);} public MySqlConnection Open(){var x=new MySqlConnection(_cfg.ConnectionString);x.Open();return x;} public Config Config=>_cfg; }
