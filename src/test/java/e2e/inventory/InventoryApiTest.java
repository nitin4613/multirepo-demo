package e2e.inventory;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class InventoryApiTest {

    @BeforeAll
    public static void setup() {
        RestAssured.baseURI = "https://api.staging.cargurus.com";
    }

    @Test
    public void testGetInventoryList() {
        when()
            .get("/api/v1/inventory")
        .then()
            .statusCode(200)
            .body("items", not(empty()));
    }

    @Test
    public void testGetInventoryItem() {
        given()
            .pathParam("vin", "1HGBH41JXMN109186")
        .when()
            .get("/api/v1/inventory/{vin}")
        .then()
            .statusCode(200)
            .body("vin", equalTo("1HGBH41JXMN109186"));
    }

    @Test
    public void testGetInventoryByDealer() {
        given()
            .queryParam("dealerId", "dealer-001")
        .when()
            .get("/api/v1/inventory")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetInventoryStats() {
        when()
            .get("/api/v1/inventory/stats")
        .then()
            .statusCode(200)
            .body("totalVehicles", greaterThan(0));
    }

    @Test
    public void testGetNewInventory() {
        given()
            .queryParam("condition", "new")
        .when()
            .get("/api/v1/inventory")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetUsedInventory() {
        given()
            .queryParam("condition", "used")
        .when()
            .get("/api/v1/inventory")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetCertifiedPreOwned() {
        given()
            .queryParam("condition", "cpo")
        .when()
            .get("/api/v1/inventory")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetInventoryByMake() {
        given()
            .queryParam("make", "Tesla")
        .when()
            .get("/api/v1/inventory")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetInventoryPriceRange() {
        given()
            .queryParam("minPrice", 25000)
            .queryParam("maxPrice", 50000)
        .when()
            .get("/api/v1/inventory")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetFeaturedInventory() {
        when()
            .get("/api/v1/inventory/featured")
        .then()
            .statusCode(200);
    }
}
