package e2e.health;

import io.restassured.RestAssured;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class HealthCheckTest {

    @BeforeAll
    public static void setup() {
        RestAssured.baseURI = "https://api.staging.cargurus.com";
    }

    @Test
    public void testHealthEndpoint() {
        when()
            .get("/health")
        .then()
            .statusCode(200)
            .body("status", equalTo("UP"));
    }

    @Test
    public void testReadinessProbe() {
        when()
            .get("/health/ready")
        .then()
            .statusCode(200);
    }

    @Test
    public void testLivenessProbe() {
        when()
            .get("/health/live")
        .then()
            .statusCode(200);
    }

    @Test
    public void testDatabaseHealth() {
        when()
            .get("/health/db")
        .then()
            .statusCode(200)
            .body("database", equalTo("UP"));
    }

    @Test
    public void testCacheHealth() {
        when()
            .get("/health/cache")
        .then()
            .statusCode(200)
            .body("cache", equalTo("UP"));
    }
}
