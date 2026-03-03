package e2e.api;

import io.restassured.RestAssured;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

/**
 * E2E API Tests for Vehicle endpoints using RestAssured
 */
public class VehicleApiTest {

    @BeforeAll
    public static void setup() {
        RestAssured.baseURI = "https://api.staging.cargurus.com";
    }

    @Test
    public void testGetVehicleById() {
        given()
            .pathParam("id", "12345")
        .when()
            .get("/api/v1/vehicles/{id}")
        .then()
            .statusCode(200)
            .body("id", equalTo("12345"))
            .body("make", notNullValue())
            .body("model", notNullValue());
    }

    @Test
    public void testGetVehicleNotFound() {
        given()
            .pathParam("id", "nonexistent")
        .when()
            .get("/api/v1/vehicles/{id}")
        .then()
            .statusCode(404);
    }

    @Test
    public void testSearchVehicles() {
        given()
            .queryParam("make", "Toyota")
            .queryParam("year", 2023)
        .when()
            .get("/api/v1/vehicles/search")
        .then()
            .statusCode(200)
            .body("results", not(empty()))
            .body("results[0].make", equalTo("Toyota"));
    }

    @Test
    public void testSearchVehiclesByPrice() {
        given()
            .queryParam("minPrice", 20000)
            .queryParam("maxPrice", 40000)
        .when()
            .get("/api/v1/vehicles/search")
        .then()
            .statusCode(200)
            .body("results.size()", greaterThan(0));
    }

    @Test
    public void testGetVehicleImages() {
        given()
            .pathParam("id", "12345")
        .when()
            .get("/api/v1/vehicles/{id}/images")
        .then()
            .statusCode(200)
            .body("images", not(empty()));
    }
}
