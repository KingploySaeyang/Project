const mongoose = require('mongoose');

const bookingSchema = new mongoose.Schema({
    bookingId: { type: mongoose.Types.ObjectId, required: false, unique: true },
    MeetingRoomNumber: { type: String, required: true }, // หมายเลขห้องที่ถูกจอง
    id: { type: String, required: true }, // ID ของผู้ใช้ที่จอง
    bookingDate: { type: Date, required: true }, // วันที่จอง
    status: { type: String, default: 'pending' }, // สถานะการจอง (pending, approved, rejected)
    approved: { type: Boolean, default: false } // การอนุมัติการจอง (false = ยังไม่อนุมัติ, true = อนุมัติ)
});

const Booking = mongoose.model('Booking', bookingSchema);
module.exports = Booking;



