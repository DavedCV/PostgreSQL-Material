import java.sql.DriverManager;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {

        /*
        DriverManager.drivers().forEach(
                driver -> System.out.println(driver.toString())
        );
        */

        App app = new App();

        // app.getActorCount();
        //app.getActors();
        // app.getActorById(100);
        // int davidId = app.insertActor(new Actor("David", "Castrillon"));

        /*
        ArrayList<Actor> actors = new ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            actors.add(new Actor("test_name_" + i, "test_lastname_" + i));
        }
        app.insertActors(actors);
        */

        // app.getActorById(davidId);
        // app.updateLastName(davidId, "Vallejo");
        // app.getActorById(davidId);

        // ok transaction
        // app.addActorAndAssignFilm(new Actor("Bruce", "Lee"), 1);

        // fail transaction
        app.addActorAndAssignFilm(new Actor("Lily", "Lee"), 9999);

    }
}