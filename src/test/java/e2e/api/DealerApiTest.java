package e2e.api;

import io.restassured.RestAssured;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class DealerApiTest {

    @BeforeAll
    public static void setup() {
        RestAssured.baseURI = "https://api.staging.cargurus.com";
    }

    @Test
    public void testGetDealerById() {
        given()
            .pathParam("id", "dealer-001")
        .when()
            .get("/api/v1/dealers/{id}")
        .then()
            .statusCode(200)
            .body("name", notNullValue())
            .body("address", notNullValue());
    }

    @Test
    public void testGetDealerInventory() {
        given()
            .pathParam("dealerId", "dealer-001")
        .when()
            .get("/api/v1/dealers/{dealerId}/inventory")
        .then()
            .statusCode(200)
            .body("vehicles", not(empty()));
    }

    @Test
    public void testSearchDealersByLocation() {
        given()
            .queryParam("lat", 42.3601)
            .queryParam("lng", -71.0589)
            .queryParam("radius", 25)
        .when()
            .get("/api/v1/dealers/search")
        .then()
            .statusCode(200)
            .body("results.size()", greaterThan(0));
    }

    @Test
    public void testGetDealerReviews() {
        given()
            .pathParam("dealerId", "dealer-001")
        .when()
            .get("/api/v1/dealers/{dealerId}/reviews")
        .then()
            .statusCode(200)
            .body("averageRating", greaterThanOrEqualTo(0.0f));
    }

    @Test
    public void testGetDealerHours() {
        given()
            .pathParam("dealerId", "dealer-001")
        .when()
            .get("/api/v1/dealers/{dealerId}/hours")
        .then()
            .statusCode(200)
            .body("monday", notNullValue());
    }
}
