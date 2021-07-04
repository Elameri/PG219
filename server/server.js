const express = require("express");
const app = express();
const mongoose = require("mongoose");
const multer = require("multer");
var jwt = require('jsonwebtoken');

//const Product = require("./models/product.js");
//const { findOneAndUpdate } = require("./models/product.js");

mongoose.set('useFindAndModify', false);

const storage = multer.diskStorage({
  destination: function(req,file,cb) {
    cb(null,'./uploads/');
  },
  filename: function(req, file, cb){
    cb(null, Date.now() + file.originalname);

  }
});

const upload = multer({storage: storage});

async function connectDB() {
  await mongoose.connect(
    "mongodb+srv://inpgramDB:inpgramDB@clusterinp.58sgb.mongodb.net/inpgram_db?retryWrites=true&w=majority",{ useNewUrlParser: true, useUnifiedTopology: true }
  );

  console.log("Connected successfully to Data Base!");
}
connectDB();

app.use(express.json({ extended: false }));

app.get("/", (req, res) => res.send("Welcome to INPgram!"));
//app.get("/signup", (req, res) => res.send("SIGN UP page"));

// model for users
var schema = new mongoose.Schema({ username: "string", email: "string", password: "string", profile_picture: "string", bio: "string" });
var User = mongoose.model("User", schema);

// model for timeline images
var schema_img_tmln = new mongoose.Schema({ picture: "string", username: "string", comment: "string" });
var TimelineImages = mongoose.model("timeline_images", schema_img_tmln);

// model for following-followers
var schema_follow = new mongoose.Schema({ follower: "string", followed: "string" });
var Follows = mongoose.model("following_followers", schema_follow);

// signup route api
app.post("/signup", async (req, res) => {
  const {username, email, password, profile_picture, bio} = req.body;

  let user = await User.findOne({ email });
  if (user) {
    return res.json({ msg: "Email adress already used !"});
  }

  user = new User({
    username,
    email,
    password,
    profile_picture,
    bio,
  }); 

  console.log(user);

  await user.save();
  var token = jwt.sign({ id: user.id }, 'password');
  res.json({token: token});

});

// signin route api
app.post("/signin", async (req, res) => {
  const {email, password} = req.body;
  console.log(email);

  let user = await User.findOne({ email });
  console.log(user);
  if (!user) {
    return res.json({ msg: "There is no user with this email adress !"});
  }
  if (user.password !== password){
    return res.json({ msg: "Incorrect password" });
  }

  
  var token = jwt.sign({ id: user.id }, 'password');
  return res.json({token: token});

});

// adding profile picture route api
app.post("/add_profile_pic", async (req, res) => {
  
  const {username, profile_picture} = req.body;
  //console.log(username);
  //console.log(profile_picture);
  let futurProfilePic = profile_picture;

  const filter = { username };
  const update = { profile_picture : futurProfilePic };
  let user = await User.findOneAndUpdate(filter, update);
  //console.log(user.username);
  //console.log(user.profile_picture);

  await user.save();
  //console.log(user);

  var token = jwt.sign({ id: user.id }, 'password', { expiresIn: '24h' });
  //noTimestamp:true,
  return res.json({token: token});

});

// getting profile DATA route api
app.post("/get_profil_data", async (req, res) => {
  
  const {token} = req.body;
  //console.log(token);

  const decoded = jwt.verify(token, 'password');  
  var userId = decoded.id;
  //console.log(userId);

  let user = await User.findOne({ "_id" : userId });
  //console.log(user);

  return res.json({username: user.username, profile_picture: user.profile_picture, bio: user.bio});

});

// change bio route api
app.post("/add_bio", async (req, res) => {
  
  const {token, bio} = req.body;
  //console.log(token);
  let myBio = bio;
  //console.log(myBio);

  const decoded = jwt.verify(token, 'password');  
  var userId = decoded.id;

  const filter = { "_id" : userId };
  const update = { bio : myBio };
  let user = await User.findOneAndUpdate(filter, update);
  //console.log(user);
  //console.log({profile_picture: user.profile_picture});

  return res.json({profile_picture: user.profile_picture});

});

// adding timeline picture route api
app.post("/add_pic", async (req, res) => {
  
  const {username, picture} = req.body;
  //console.log(username);
  console.log(picture);

  let comment = "";

  let img = new TimelineImages({
    picture,
    username,
    comment,
  }); 

  //console.log(img);

  await img.save();
  //res.json({token: token});

});

// change caption route api
app.post("/add_caption_img", async (req, res) => {
  
  const {username, picture, comment} = req.body;
  let myUsername = username;
  let myPicture = picture;
  let myComment = comment;
  //console.log(myComment);

  let img = new TimelineImages({
    picture,
    username,
    comment,
  }); 

  //console.log(img);
  await img.save();

});

// get timeline route api
app.post("/get_timeline_pics", async (req, res) => {
  
  const {username} = req.body;
  let myUsername = username;
  //let myComment = comment;
  //console.log("myUsername");
  //console.log(username);

  let img = await TimelineImages.find({ username : myUsername }).sort({_id:-1}) ;

  var imgTimeline = [];
  img.forEach(function(item, index, array) {
    imgTimeline.push(item.picture);
    //console.log(item, index);
  });


  //console.log(imgTimeline);
  return res.json({pics: imgTimeline});

});


// delete img route api
app.post("/cancel_img", async (req, res) => {
  
  const {username, picture} = req.body;
  let myUsername = username;
  let myPicture = picture;
  //console.log("myUsername then myPicture");
  //console.log(username);
  //console.log(picture);

  //let img = await TimelineImages.find({ username : myUsername });

  let deleted = await TimelineImages.findOneAndDelete({ picture : myPicture, username : myUsername });
  //console.log(deleted);
  
  //return res.json({pics: imgTimeline});

});


// getting profile DATA from username route api
app.post("/get_profil_data_from_username", async (req, res) => {
  
  const {username} = req.body;
  let myUsername = username;
  //console.log(username);

  let user = await User.findOne({ username : myUsername });
  //console.log(user);

  return res.json({ profile_picture: user.profile_picture, bio: user.bio});

});


// isfollowed route api
app.post("/isfollowed", async (req, res) => {
  
  const {follower, followed} = req.body;
  let theFollower = follower;
  let theFollowed = followed;
  //console.log(username);

  let flw = await Follows.find({ follower: { $exists: true, $in: [ follower ] }, followed: { $exists: true, $in: [ followed ] } }).countDocuments() ;
  //console.log("flw result");
  //console.log(flw);
  if (flw == 0){
    return res.json({ binaryFollow: 0});
  }
  else{
    return res.json({ binaryFollow: 1});
  }
  
});

// follow route api
app.post("/follow", async (req, res) => {
  
  const {follower, followed} = req.body;
  let theFollower = follower;
  let theFollowed = followed;
  //console.log(username);

  let flw = new Follows({
    follower,
    followed,
  }); 

  //console.log(flw);
  await flw.save();

});

// unfollow route api
app.post("/unfollow", async (req, res) => {
  
  const {follower, followed} = req.body;
  let theFollower = follower;
  let theFollowed = followed;
  //console.log(username);

  let deleted = await Follows.findOneAndDelete({ follower : theFollower, followed : theFollowed });
  //console.log(deleted);

});

// get followed people route api
app.post("/get_followed_people", async (req, res) => {
  
  const {username} = req.body;
  let myUsername = username;
  //let myComment = comment;
  //console.log("myUsername");
  //console.log(username);

  let people = await Follows.find({ follower : myUsername }).sort({_id:-1}) ;

  var timelineUsername = [];
  var timelineImg = [];
  var timelineCaption = [];
  var timelineProfiles = [];

  //people.forEach(function(item, index, array) {
  for (const item of people) {

    let images = await TimelineImages.find({ username : item.followed }).sort({_id:-1});
    let profile = await User.findOne({ username : item.followed });

    images.forEach(function(item, index, array) {
      timelineProfiles.push(profile.profile_picture);
      timelineUsername.push(item.username);
      timelineImg.push(item.picture);
      timelineCaption.push(item.comment);
    });

    //let profile = await User.findOne({ username : item.followed });


  }
  //});

  //console.log(peopleFollowed);
  return res.json({people: timelineUsername, images: timelineImg, captions: timelineCaption, profils: timelineProfiles});

});

// get all users route api
app.post("/get_all_users", async (req, res) => {
  
  const {username} = req.body;
  let myUsername = username;
  //console.log("myUsername");
  //console.log(username);

  let people = await User.find({});

  var allUsername = [];

  for (const item of people) {
    if( item.username != myUsername){
      allUsername.push(item.username);
    }
  }

  //console.log(peopleFollowed);
  return res.json({people: allUsername});

});

// search users route api
app.post("/search_users", async (req, res) => {
  
  const {name} = req.body;
  //console.log(token);
  let myUserSearched = '^' + name;
  //console.log(myUserSearched);

  let user = await User.find({username: { '$regex': '^'+myUserSearched, '$options': 'i' }}, {});

  //console.log(user);

  var allUsername = [];
  for (const item of user) {
    allUsername.push(item.username);
  }

  return res.json({searchresult: allUsername});

});


app.listen(5000, () => console.log("Listening on port 5000!"));