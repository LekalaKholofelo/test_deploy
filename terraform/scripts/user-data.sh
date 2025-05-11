#!/bin/bash
# Install Node.js and dependencies
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs git

# Set working directory
mkdir -p /opt/stellarpath
cd /opt/stellarpath

# Copy or clone project files (if you have an S3 or Git repo, replace this accordingly)
# This assumes the backend and frontend files are baked into the AMI or attached via EBS
# Here we simulate placement
echo "Setting up backend and frontend"

cat <<EOF > /opt/stellarpath/server.js
const express = require('express');
const db = require('./db');
const app = express();
const PORT = process.env.PORT || 3000;
app.use(express.static('frontend'));
app.get('/welcome', async (req, res) => {
  try {
    const message = await db.getWelcomeMessage();
    res.send(message);
  } catch (err) {
    res.status(500).send("Error fetching welcome message.");
  }
});
app.listen(PORT, () => console.log(`Server started on ${PORT}`));
EOF

cat <<EOF > /opt/stellarpath/db.js
const {{ Client }} = require('pg');
require('dotenv').config();
async function getWelcomeMessage() {
  const client = new Client({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT
  });
  await client.connect();
  const res = await client.query('SELECT message FROM welcome LIMIT 1');
  await client.end();
  return res.rows[0]?.message || 'Welcome to StellarPath';
}
module.exports = {{ getWelcomeMessage }};
EOF

# Install backend dependencies
npm install express pg dotenv

# Start the backend
node server.js > /var/log/stellarpath.log 2>&1 &