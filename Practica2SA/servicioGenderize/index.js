const express = require('express');
const axios = require('axios');
const app = express();
const port = 3001; // Asegúrate de que este puerto sea diferente para cada microservicio

app.get('/genderize', async (req, res) => {
  const name  = req.query.name;
  try {
    const response = await axios.get(`https://api.genderize.io/?name=${name}`);
    res.json(response.data);
  } catch (error) {
    res.status(500).send(error.toString());
  }
});

app.listen(port, () => {
  console.log(`Genderize service listening at http://localhost:${port}`);
});
