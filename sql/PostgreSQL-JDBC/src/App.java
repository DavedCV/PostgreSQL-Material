import java.sql.*;
import java.util.List;

public class App {

    private final String url = "jdbc:postgresql://localhost/dvdrental";
    private final String user = "postgres";
    private final String password = "postgres";

    public Connection connect() {

        Connection conn = null;
        try {
            conn = DriverManager.getConnection(url, user, password);
            // System.out.println("Conected to the PostgreSQL server sucessfully!");
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return conn;
    }

    // Retrieve only one row
    public int getActorCount() {
        String SQL = "SELECT COUNT(*) FROM actor";

        int count = 0;

        try (
            Connection conn = connect();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(SQL);
        ) {
            rs.next();
            count = rs.getInt(1);
            System.out.println("Total number of actors: " + count);
        }catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return count;
    }

    // Retrieve multiple rows
    public void getActors() {
        String SQL = "SELECT actor_id, first_name, last_name FROM actor";

        try (
            Connection conn = connect();
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(SQL);
        ) {
            while (rs.next()) {
                System.out.println(
                        rs.getString("actor_id") + "\t"
                        + rs.getString("first_name") + "\t"
                        + rs.getString("last_name")
                );
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    // Using statement that has parameters
    public void getActorById(int id) {
        String SQL = "SELECT actor_id, first_name, last_name FROM actor WHERE actor_id = ?";

        try (
            Connection conn = connect();
            PreparedStatement pstmt = conn.prepareStatement(SQL);
        ) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            rs.next();
            System.out.println(
                    rs.getString("actor_id") + "\t"
                    + rs.getString("first_name") + "\t"
                    + rs.getString("last_name")
            );
        } catch (SQLException e){
            System.out.println(e.getMessage());
        }
    }

    // Insert a row into a table
    public int insertActor(Actor actor) {
        String SQL = "INSERT INTO actor(first_name, last_name) VALUES (?, ?)";

        int id = 0;

        try (
            Connection conn = connect();
            PreparedStatement pstmt = conn.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS);
        ) {
            pstmt.setString(1, actor.getFirstName());
            pstmt.setString(2, actor.getLastName());

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                // Get the ID back
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        id = rs.getInt(1);
                        System.out.println(
                                "New actor '"
                                + actor.getFirstName() + " "
                                + actor.getLastName()
                                + "' inserted with id: " + id
                        );
                    }
                } catch (SQLException e) {
                    System.out.println(e.getMessage());
                }
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        return id;
    }

    // Insert multiple rows in a table
    public void insertActors(List<Actor> list) {
        String SQL = "INSERT INTO actor(first_name, last_name) VALUES (?, ?)";

        try (
            Connection conn = connect();
            PreparedStatement stmt = conn.prepareStatement(SQL);
        ) {
            int count = 0;

            for (Actor actor : list) {
                stmt.setString(1, actor.getFirstName());
                stmt.setString(2, actor.getLastName());

                stmt.addBatch();
                count++;

                // execute every 100 rows
                if (count % 100 == 0 || count == list.size()) {
                    stmt.executeBatch();
                }
            }

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }

        System.out.println("Actors successfully added!");
    }

    public void updateLastName(int id, String lastName) {
        String SQL = "UPDATE actor SET last_name = ? WHERE actor_id = ?";

        try (
            Connection conn = connect();
            PreparedStatement pstmt = conn.prepareStatement(SQL);
        ) {
            pstmt.setString(1, lastName);
            pstmt.setInt(2, id);

            int affectedRows = pstmt.executeUpdate();

            System.out.println("Lastname updated, the number of affected rows is: " + affectedRows);

        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }

    public void deleteActor(int id) {
        String SQL = "DELETE FROM actor WHERE actor_id = ?";

        try (
            Connection conn = connect();
            PreparedStatement pstmt = conn.prepareStatement(SQL)
        ) {
            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();
            System.out.println("Deleted row with id " + id + " and affected " + affectedRows + " rows");

        } catch (SQLException ex) {
            System.out.println(ex.getMessage());
        }
    }
}
