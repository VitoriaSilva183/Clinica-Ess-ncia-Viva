using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
namespace ClinicaEsteticaWeb.Services;
public class Config { private readonly IConfiguration _c; public Config(IConfiguration c){_c=c;} public string ConnectionString=>_c["ConnectionString"] ?? throw new InvalidOperationException("ConnectionString não configurada."); public int Timeout=>int.TryParse(_c["SessionTimeoutMinutes"],out var n)&&n>0?n:15; public byte[] Key { get { var s=_c["EncryptionKeyBase64"]; if(string.IsNullOrWhiteSpace(s)) throw new InvalidOperationException("EncryptionKeyBase64 não configurada."); var b=Convert.FromBase64String(s); if(b.Length!=32) throw new InvalidOperationException("A chave deve ter 32 bytes."); return b; } } }
