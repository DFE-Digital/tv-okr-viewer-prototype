const express = require("express");
const cors = require("cors");
const { Pool } = require("pg");

const app = express();
const port = 3000;

app.use(express.json());
app.use(cors({
  origin: "http://localhost:8080"
}));

const pool = new Pool({
  host: process.env.POSTGRES_HOST,
  port: process.env.POSTGRES_PORT || 5432,
  database: process.env.POSTGRES_DB,
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD
});

app.get("/health", (req, res) => {
  res.json({
    status: "ok",
    service: "TVS Roadmap API"
  });
});

app.get("/health/database", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT current_database() AS database, current_user AS user"
    );

    res.json({
      status: "ok",
      database: result.rows[0].database,
      user: result.rows[0].user
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "Database connection failed"
    });
  }
});

app.get("/live", (req, res) => {
  res.json({
    status: "ok"
  });
});

app.get("/ready", async (req, res) => {
  try {
    await pool.query("SELECT 1");

    res.json({
      status: "ok"
    });
  } catch (error) {
    console.error("Readiness check failed:", error);

    res.status(503).json({
      status: "not ready"
    });
  }
});

app.get("/api/activities", async (req, res) => {
  try {
const result = await pool.query(`
  SELECT
    id,
    objective,
    key_result AS "keyResult",
    workstream,
    activity,
    start_sprint AS "startSprint",
    CASE
      WHEN start_sprint IS NOT NULL AND end_sprint IS NOT NULL
      THEN end_sprint - start_sprint + 1
      ELSE NULL
    END AS "durationSprints",
    end_sprint AS "endSprint",
    status,
    delivery_link AS "deliveryLink",
    depends_on AS "dependsOn",
    schedule_basis AS "scheduleBasis"
  FROM activities
  ORDER BY id
`);

    res.json(result.rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "Failed to retrieve activities"
    });
  }
});

app.post("/api/activities", async (req, res) => {
  try {
    const {
      objective,
      keyResult,
      workstream,
      activity,
      startSprint,
      endSprint,
      status,
      deliveryLink,
      dependsOn,
      scheduleBasis
    } = req.body;

    const result = await pool.query(
      `INSERT INTO activities
        (objective, key_result, workstream, activity, start_sprint, end_sprint,
         status, delivery_link, depends_on, schedule_basis)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING *`,
      [
        objective,
        keyResult,
        workstream,
        activity,
        startSprint || null,
        endSprint || null,
        status || "Not started",
        deliveryLink || null,
        dependsOn || null,
        scheduleBasis || null
      ]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "Failed to create activity"
    });
  }
});

app.put("/api/activities/:id", async (req, res) => {
  try {
    const {
      objective,
      keyResult,
      workstream,
      activity,
      startSprint,
      endSprint,
      status,
      deliveryLink,
      dependsOn,
      scheduleBasis
    } = req.body;

    const result = await pool.query(
      `UPDATE activities
       SET objective = $1,
           key_result = $2,
           workstream = $3,
           activity = $4,
           start_sprint = $5,
           end_sprint = $6,
           status = $7,
           delivery_link = $8,
           depends_on = $9,
           schedule_basis = $10
       WHERE id = $11
       RETURNING *`,
      [
        objective,
        keyResult,
        workstream,
        activity,
        startSprint || null,
        endSprint || null,
        status || "Not started",
        deliveryLink || null,
        dependsOn || null,
        scheduleBasis || null,
        req.params.id
      ]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "Activity not found"
      });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "Failed to update activity"
    });
  }
});

app.delete("/api/activities/:id", async (req, res) => {
  try {
    const result = await pool.query(
      "DELETE FROM activities WHERE id = $1 RETURNING id",
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        status: "error",
        message: "Activity not found"
      });
    }

    res.json({
      status: "ok",
      deletedId: result.rows[0].id
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      status: "error",
      message: "Failed to delete activity"
    });
  }
});

app.listen(port, "0.0.0.0", () => {
  console.log(`TVS Roadmap API listening on port ${port}`);
});