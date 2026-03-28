### .NET API para el funcionamiento de la app

``` c#
    
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using perueba1.Entidades;
using System.Data.SqlTypes;



namespace perueba1.Controllers
{
    [ApiController]
    [Route("api/autores")]
    public class AutoresControllers : ControllerBase //herencia de ControllerBase 
    {
        private readonly string? _connectionString;
        //ctor y tecla tab para agregar el constructor de la clase
        public AutoresControllers(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        [HttpGet] // Método Get
        public async Task<ActionResult<IEnumerable<Autores>>> GetConsultaADO()
        {
            var autores = new List<Autores>();

            try
            {
                using (SqlConnection oConn = new SqlConnection(_connectionString))
                {
                    await oConn.OpenAsync();

                    using (SqlCommand oCmd = new SqlCommand("SELECT Id, Nombre From Autores", oConn))
                    {
                        oCmd.CommandType = System.Data.CommandType.Text;

                        using (SqlDataReader reader = await oCmd.ExecuteReaderAsync())
                        {
                            while (await reader.ReadAsync())
                            {
                                autores.Add(new Autores
                                {
                                    Id = (int)reader["Id"],
                                    Nombre = reader["Nombre"].ToString()
                                });
                            }
                        }
                    }
                }
                return Ok(autores);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error interno: {ex.Message}");
            }
        }
        [HttpPost("introducir")]
        public async Task<ActionResult> SetFixedValues()
        {
            try
            {
                using (SqlConnection oConn = new SqlConnection(_connectionString))
                {
                    await oConn.OpenAsync();

                    // Aquí "anotas" los valores directamente en el string de SQL
                    string query = "INSERT INTO Autores (Nombre) VALUES ('Isaac Rodriguez Acuña')";

                    using (SqlCommand oCmd = new SqlCommand(query, oConn))
                    {
                        await oCmd.ExecuteNonQueryAsync();
                    }
                }
                return Ok("Autor fijo insertado.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error: {ex.Message}");
            }
        }
        [HttpDelete("eliminar")]
        public async Task<ActionResult> DeleteFixedValue()
        {
            // El nombre está escrito directamente en el DELETE
            string query = "DELETE FROM Autores WHERE Nombre = 'Eric Hernandez'";

            using (SqlConnection oConn = new SqlConnection(_connectionString))
            {
                await oConn.OpenAsync();
                using (SqlCommand oCmd = new SqlCommand(query, oConn))
                {
                    // Simplemente ejecutamos la instrucción
                    await oCmd.ExecuteNonQueryAsync();
                }
            }

            return Ok("El autor configurado ha sido eliminado.");
        }

    }
}
```