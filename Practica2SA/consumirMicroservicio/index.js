const express = require('express');
const axios = require('axios');
const app = express();
const port = 3000;

app.get('/info', async (req, res) => {
  const  name  = req.query.name;
  try {
    const genderResponse = await axios.get(`http://localhost:3001/genderize?name=${name}`);
    const ageResponse = await axios.get(`http://localhost:3002/agify?name=${name}`);
    res.json({
      name,
      genderize: genderResponse.data,
      agify: ageResponse.data
    });
  } catch (error) {
    res.status(500).send(error.toString());
  }
});

app.listen(port, () => {
  console.log(`Main service listening at http://localhost:${port}`);
});
