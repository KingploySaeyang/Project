require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('./models/user'); // โมเดลผู้ใช้ใน MongoDB

const app = express();
app.use(express.json());

// เชื่อมต่อกับ MongoDB
mongoose.connect(process.env.MONGO_DB_URI, {})
    .then(async () => {  // ทำให้ฟังก์ชันเป็น asynchronous
        console.log('MongoDB connected');

        // ลบเอกสารที่มี roomNumber เป็น null
        await mongoose.connection.db.collection('rooms').deleteMany({ MeetingRoomNumber: null });
        console.log('Deleted documents with MeetingRoomNumber as null');
    })
    .catch(err => console.error('Failed to connect to MongoDB:', err));

// Config Route
const bookingRoutes = require('./routes/booking'); // เส้นทางการจัดการข้อมูลการจองห้องประชุม
app.use('/api/booking', bookingRoutes); // เปลี่ยนเส้นทางเป็น /api/admin

const authRoutes = require('./routes/auth'); // เส้นทางการจัดการผู้ใช้
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
