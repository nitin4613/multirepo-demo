package e2e.search;

import io.restassured.RestAssured;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class SearchApiTest {

    @BeforeAll
    public static void setup() {
        RestAssured.baseURI = "https://api.staging.demo.com";
    }

    @Test
    public void testBasicSearch() {
        given()
            .queryParam("q", "honda civic")
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200)
            .body("totalResults", greaterThan(0));
    }

    @Test
    public void testSearchWithFilters() {
        given()
            .queryParam("make", "Honda")
            .queryParam("model", "Civic")
            .queryParam("yearMin", 2020)
            .queryParam("yearMax", 2024)
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200)
            .body("results", not(empty()));
    }

    @Test
    public void testSearchPagination() {
        given()
            .queryParam("q", "toyota")
            .queryParam("page", 2)
            .queryParam("limit", 20)
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200)
            .body("page", equalTo(2))
            .body("results.size()", lessThanOrEqualTo(20));
    }

    @Test
    public void testSearchSortByPrice() {
        given()
            .queryParam("q", "bmw")
            .queryParam("sort", "price_asc")
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200);
    }

    @Test
    public void testSearchSortByMileage() {
        given()
            .queryParam("q", "ford")
            .queryParam("sort", "mileage_asc")
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200);
    }

    @Test
    public void testSearchByZipCode() {
        given()
            .queryParam("zip", "02142")
            .queryParam("radius", 50)
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200);
    }

    @Test
    public void testSearchByBodyType() {
        given()
            .queryParam("bodyType", "SUV")
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200)
            .body("results[0].bodyType", equalTo("SUV"));
    }

    @Test
    public void testSearchByFuelType() {
        given()
            .queryParam("fuelType", "Electric")
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200);
    }

    @Test
    public void testSearchByTransmission() {
        given()
            .queryParam("transmission", "Automatic")
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200);
    }

    @Test
    public void testSearchByColor() {
        given()
            .queryParam("exteriorColor", "Black")
        .when()
            .get("/api/v1/search")
        .then()
            .statusCode(200);
    }
}
