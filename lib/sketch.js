function setup() {
  createCanvas(400, 400);
  background(220);
  text('grises :'+ mouseX,10,10)
}

function draw() {
  
  let x = constrain (mouseX, 0,255);
 
  
  fill(x);
  rect ( width/2, height/2, 200, 150)
  
}
