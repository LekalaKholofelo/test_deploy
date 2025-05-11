const express = require('express');
const { Pool } = require('pg');
const path = require('path');

const app = express();
const port = process.env.PORT || 3000;

// PostgreSQL pool
const pool = new Pool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: process.env.DB_NAME,
    port: 5432,
});

app.use(express.static(path.join(__dirname, '../frontend')));

app.get('/welcome', async (req, res) => {
    try {
        const result = await pool.query('SELECT message FROM welcome_messages LIMIT 1');
        res.json({ message: result.rows[0]?.message || 'No message found' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to fetch message' });
    }
});

app.listen(port, () => {
    console.log(`Server running on port ${port}`);
});
