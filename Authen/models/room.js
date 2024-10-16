const mongoose = require('mongoose');

const roomSchema = new mongoose.Schema({
    MeetingRoomNumber: { type: String, required: true, unique: true,},
    floor: { type: String, required: true,},
    status: { type: String, required: true,
        enum: ['available', 'booked', 'pending'], // ตัวอย่างค่าที่สามารถใช้ได้
    }
});

const Room = mongoose.model('Room', roomSchema); // สร้างโมเดล Room
module.exports = Room;