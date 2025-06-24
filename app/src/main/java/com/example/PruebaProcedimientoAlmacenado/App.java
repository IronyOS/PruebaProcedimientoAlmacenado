import java.sql.*;
import java.util.Scanner;

public class App {

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        System.out.print("ID del cliente: ");
        int idCliente = scanner.nextInt();

        System.out.print("ID del producto: ");
        int idProducto = scanner.nextInt();

        System.out.print("Cantidad a comprar: ");
        int cantidad = scanner.nextInt();

        try {
          
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/CompuTienda",
                "root", 
                "2012" 
            );

  
            CallableStatement stmt = conn.prepareCall("{ CALL RealizarVenta(?, ?, ?) }");
            stmt.setInt(1, idCliente);
            stmt.setInt(2, idProducto);
            stmt.setInt(3, cantidad);

            stmt.execute();

            System.out.println("✅ Venta realizada con éxito.");

            stmt.close();
            conn.close();

        } catch (SQLException e) {

            System.out.println("❌ Error durante la venta: " + e.getMessage());
        }
    }
}
