const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(bodyParser.json());

// Fake data
const db = {
  "users": [
    {
      "id": "1",
      "firstName": "Sheldon",
      "lastName": "Quigley",
      "age": 28,
      "gender": "male",
      "email": "hbingley1@plala.or.jp",
      "phone": "+7 813 117 7139",
      "image": "https://robohash.org/Sheldon.png?set=set4"
    },
    {
      "id": "2",
      "firstName": "Terrill",
      "lastName": "Hills",
      "age": 38,
      "gender": "male",
      "email": "rshawe2@51.la",
      "phone": "+63 739 292 7942",
      "image": "https://robohash.org/Terrill.png?set=set4"
    }
  ],
  "department": [
    {
      "id": "1",
      "firstName": "ahmed",
      "lastName": "Medhurst",
      "age": 50,
      "gender": "male",
      "email": "atuny0@sohu.com",
      "phone": "+63 791 675 8914",
      "image": "https://robohash.org/Terry.png?set=set4"
    },
    {
      "id": "2",
      "firstName": "Sheldon",
      "lastName": "Quigley",
      "age": 28,
      "gender": "male",
      "email": "hbingley1@plala.or.jp",
      "phone": "+7 813 117 7139",
      "image": "https://robohash.org/Sheldon.png?set=set4"
    },
    {
      "id": "3",
      "firstName": "Terrill",
      "lastName": "Hills",
      "age": 38,
      "gender": "male",
      "email": "rshawe2@51.la",
      "phone": "+63 739 292 7942",
      "image": "https://robohash.org/Terrill.png?set=set4"
    }
  ]
};

// Endpoint to get all data
app.get('/db', (req, res) => {
  res.json({ db });
});

// Endpoint to get users
app.get('/db/users', (req, res) => {
  res.json({ users: db.users });
});

// Endpoint to get a specific user by ID
app.get('/db/users/:id', (req, res) => {
  const user = db.users.find(u => u.id === req.params.id);
  if (user) {
    res.json(user);
  } else {
    res.status(404).json({ error: 'User not found' });
  }
});

// Endpoint to get departments
app.get('/db/department', (req, res) => {
  res.json({ department: db.department });
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
