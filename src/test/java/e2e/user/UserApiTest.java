package e2e.user;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.*;

public class UserApiTest {

    @BeforeAll
    public static void setup() {
        RestAssured.baseURI = "https://api.staging.demo.com";
    }

    @Test
    public void testGetUserProfile() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me")
        .then()
            .statusCode(200)
            .body("email", notNullValue());
    }

    @Test
    public void testGetUserSavedSearches() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me/saved-searches")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetUserFavorites() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me/favorites")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetUserAlerts() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me/alerts")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetUserRecentlyViewed() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me/recently-viewed")
        .then()
            .statusCode(200);
    }

    @Test
    public void testUnauthorizedAccess() {
        when()
            .get("/api/v1/users/me")
        .then()
            .statusCode(401);
    }

    @Test
    public void testGetUserPreferences() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me/preferences")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetUserNotifications() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me/notifications")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetUserSearchHistory() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me/search-history")
        .then()
            .statusCode(200);
    }

    @Test
    public void testGetUserMessages() {
        given()
            .header("Authorization", "Bearer test-token")
        .when()
            .get("/api/v1/users/me/messages")
        .then()
            .statusCode(200);
    }
}
