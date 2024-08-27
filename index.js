const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello from Arslan and testing github action and let me kn woti skwoj nsdie  main kdieh ');
});

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});