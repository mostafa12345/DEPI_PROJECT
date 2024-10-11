const { MongoClient } = require('mongodb');

// Use when starting MongoDB as a separate Docker container
let mongoUrlDocker = "mongodb://admin:password@host.docker.internal:27017";

// Use when starting MongoDB as part of docker-compose
let mongoUrlDockerCompose = "mongodb://admin:password@mongodb";
const dbName = 'user-account';
const collectionName = 'users';

async function createCollection() {
  const client = new MongoClient(mongoUrlDockerCompose);

  try {
    await client.connect();
    console.log('Connected correctly to MongoDB server');

    const db = client.db(dbName);

    const collection = db.collection(collectionName);
    await collection.insertOne({ initialized: true });
    console.log(`Collection ${collectionName} created in database ${dbName}`);
  } catch (err) {
    console.error(err);
  } finally {
    await client.close();
  }
}

createCollection();