const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello World new update i am arslan and testing my website');
});

app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`);
});