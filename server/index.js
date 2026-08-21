const express=require('express');
const http=require('http');
const {Server}=require('socket.io');
const app=express();
const server=http.createServer(app);
const io=new Server(server,{cors:{origin:'*'}});
const rooms=new Map();
app.use(express.json());
app.get('/',(req,res)=>res.send('WebRTC server running'));
app.post('/create-room',(req,res)=>{
 const id='CAM-'+Math.random().toString(36).substring(2,8).toUpperCase();
 const pin=Math.floor(1000+Math.random()*9000).toString();
 rooms.set(id,{pin,created:Date.now()});
 res.json({roomId:id,pin,watchUrl:`/watch/${id}`});
});
app.use(express.static('../web'));
io.on('connection',socket=>{
 socket.on('join',room=>{socket.join(room);socket.data.room=room;socket.to(room).emit('peer-joined');});
 ['offer','answer','ice'].forEach(t=>socket.on(t,d=>{if(socket.data.room) socket.to(socket.data.room).emit(t,d);}));
 socket.on('disconnect',()=>{if(socket.data.room) socket.to(socket.data.room).emit('peer-left');});
});
server.listen(process.env.PORT||8080,()=>console.log('running'));
