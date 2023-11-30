// import express from "express";
// import Connection from "./database/db.js";
// import dotenv from "dotenv";
// import cors from "cors";
// import Routes from "./routes/route.js";
// import bodyParser from "body-parser";
// import cookieParser from "cookie-parser";
// import session from "express-session";
// import MongoStore from "connect-mongo";

const express = require("express");
const connection = require("./database/db.js");
const dotenv = require("dotenv");
const cors = require("cors");
const Routes = require("./routes/route.js");
const bodyParser = require("body-parser");
const cookieParser = require("cookie-parser");
const session = require("express-session");
const MongoStore = require("connect-mongo");
const path = require("path");

// Initialize express
const app = express();
const PORT = process.env.PORT || 8000;

// dotenv is used to store passwords
dotenv.config();

const username = "kurafinalpj";
const password = "kurafinalpj";

const URL = `mongodb+srv://kurafinalpj:kurafinalpj@cluster0.mjwldbe.mongodb.net/?retryWrites=true&w=majority`;

// username and passwords passed as a parameter in Connection function
connection.Connection(username, password);

app.use(bodyParser.json({ extended: true }));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());

app.use(
  session({
    secret: "asdfefna",
    saveUninitialized: false,
    resave: false,
    store: MongoStore.create({
      mongoUrl: URL,
    }),
    cookie: {
      expires: 60 * 60 * 24 * 1000 * 30,
    },
  })
);
app.use(express.json());
// To initialize cors
app.use(
  cors({
    origin: true,
    method: ["GET", "POST"],
    credentials: true,
  })
); // It help in sending data from one end point to another end point

app.use(express.static(path.join(__dirname + "/public")));
// For handling many requests
app.use("/", Routes);

app.listen(PORT, () => console.log(`Server is running`));
