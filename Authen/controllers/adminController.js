const mongoose = require('mongoose');
const Room = require("../models/room"); // นำเข้าโมเดล Room
const Booking = require("../models/booking"); // นำเข้าโมเดล Booking
const User = require("../models/user"); // นำเข้าโมเดล User

// ฟังก์ชันสำหรับเพิ่มห้องประชุม
exports.addRoom = async (req, res) => {
    try {
        const { MeetingRoomNumber, floor, status } = req.body; // ดึง MeetingRoomNumber, floor, และ status

        // ตรวจสอบว่า MeetingRoomNumber ถูกส่งมาหรือไม่
        if (!MeetingRoomNumber) {
            return res.status(400).json({ message: 'Meeting room number is required' }); // ส่งข้อความถ้าไม่มี MeetingRoomNumber
        }

        // ตรวจสอบว่าห้องประชุมมีอยู่แล้วในฐานข้อมูลหรือไม่
        const existingRoom = await Room.findOne({ MeetingRoomNumber });
        if (existingRoom) {
            return res.status(400).json({ message: 'Room already exists with this Meeting Room Number' }); // ถ้ามีห้องประชุมนี้อยู่แล้ว
        }

        // ตรวจสอบค่า floor และ status ก่อนการสร้างห้องประชุม
        if (!floor || !status) {
            return res.status(400).json({ message: 'Floor and status are required' }); // ส่งข้อความถ้าไม่มีค่า floor หรือ status
        }

        const room = new Room({ MeetingRoomNumber, floor, status }); // สร้างห้องประชุมใหม่
        await room.save(); // บันทึกห้องประชุมลงฐานข้อมูล

        res.status(201).json({ message: 'Room added successfully', room }); // ส่งข้อความยืนยันการเพิ่ม
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};

// ฟังก์ชันสำหรับจองห้องประชุม
exports.bookingRoom = async (req, res) => {
    try {
        const { MeetingRoomNumber, id, bookingDate } = req.body; // ดึงข้อมูลจาก request body

        // ค้นหาห้องประชุมตาม MeetingRoomNumber
        const room = await Room.findOne({ MeetingRoomNumber });
        if (!room) {
            return res.status(404).json({ message: 'Room not found' }); // ถ้าไม่พบห้องประชุม
        }

        // ตรวจสอบสถานะห้องประชุม
        if (room.status !== 'available') {
            return res.status(400).json({ message: 'Room is not available for booking' }); // ถ้าห้องไม่ว่าง
        }

        // ตรวจสอบว่าผู้ใช้มีการจองที่ยังไม่คืน
        const activeBooking = await Booking.findOne({
            id,
            status: { $in: ['booked', 'pending'] } // ตรวจสอบทั้งสถานะ 'booked' และ 'pending'
        });

        // แสดงค่าที่ค้นหาใน console
        console.log("Searching for active bookings with id:", id);

        // ตรวจสอบผลลัพธ์
        if (activeBooking) {
            console.log("Active booking found:", activeBooking);
            return res.status(400).json({ message: 'You have an active booking that is not yet returned' });
        }

        // สร้างการจองใหม่ในโมเดล Booking
        const booking = new Booking({
            bookingId: new mongoose.Types.ObjectId(), // ตั้งค่า bookingId ใหม่
            MeetingRoomNumber,
            id,
            bookingDate,
            status: 'pending', // สถานะการจองเริ่มต้น
            approved: false // ค่า default สำหรับ approved
        });
        await booking.save(); // บันทึกการจอง

        // อัปเดตสถานะห้องประชุมเป็น 'booked'
        room.status = 'booked';
        await room.save(); // บันทึกการเปลี่ยนแปลงสถานะห้องประชุม

        res.status(201).json({ message: 'Room booked successfully', bookingId: booking.bookingId }); // ส่งข้อความยืนยันการจองและ bookingId
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};
// ฟังก์ชันดึงสถานะของห้องประชุมทั้งหมด
exports.checkRoomStatus = async (req, res) => {
    try {
        const rooms = await Room.find(); // ค้นหาห้องประชุมทั้งหมด
        res.status(200).json(rooms); // ส่งสถานะห้องประชุมกลับไป
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};

// ฟังก์ชันดึงข้อมูลการจองทั้งหมด
exports.getBookings = async (req, res) => {
    try {
        const bookings = await Booking.find().populate('id', 'username name'); // ดึงข้อมูลการจองทั้งหมดและ populate ข้อมูลผู้ใช้ตาม id
        res.status(200).json(bookings); // ส่งข้อมูลการจองกลับไป
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};


// ฟังก์ชันอนุมัติการจองห้องประชุมโดยใช้ MeetingRoomNumber
exports.approveBooking = async (req, res) => {
    try {
        const { MeetingRoomNumber } = req.body; // ดึง MeetingRoomNumber จาก request body

        // ตรวจสอบค่า MeetingRoomNumber
        if (!MeetingRoomNumber) {
            return res.status(400).json({ message: 'Meeting Room Number is required' }); // ถ้าไม่มี MeetingRoomNumber
        }

        // ตรวจสอบให้แน่ใจว่า MeetingRoomNumber เป็นสตริง
        if (typeof MeetingRoomNumber !== 'string' || MeetingRoomNumber.trim() === '') {
            return res.status(400).json({ message: 'Meeting Room Number must be a valid string' }); // ถ้า MeetingRoomNumber ไม่ใช่สตริงที่ถูกต้อง
        }

        // ค้นหาและอัปเดตการจองโดยใช้ MeetingRoomNumber
        const updatedBooking = await Booking.findOneAndUpdate(
            { MeetingRoomNumber: MeetingRoomNumber, status: 'pending' }, // เงื่อนไข: ห้องที่ยังไม่ได้รับการอนุมัติ
            { 
                status: 'approved',  // เปลี่ยนสถานะเป็น 'approved'
                approved: true       // เปลี่ยน approved เป็น true
            },
            { new: true }
        );

        if (!updatedBooking) {
            return res.status(404).json({ message: 'Booking not found or already approved' }); // ถ้าหาไม่เจอการจองที่ต้องการ
        }

        res.status(200).json({ message: 'Booking approved', updatedBooking });
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาดในกรณีมีข้อผิดพลาด
    }
};

exports.returnRoom = async (req, res) => {
    try {
        const { MeetingRoomNumber } = req.body; // ดึง MeetingRoomNumber จาก request body

        // ตรวจสอบค่า MeetingRoomNumber
        if (!MeetingRoomNumber) {
            return res.status(400).json({ message: 'Meeting Room Number is required' }); // ถ้าไม่มี MeetingRoomNumber
        }

        // ค้นหาการจองในโมเดล Booking โดยใช้ MeetingRoomNumber
        const booking = await Booking.findOne({ MeetingRoomNumber: MeetingRoomNumber });
        if (!booking) {
            return res.status(404).json({ message: 'Booking not found' }); // ถ้าไม่พบการจอง
        }

        // อัปเดตสถานะห้องประชุมให้กลับมาเป็น 'available'
        const room = await Room.findOne({ MeetingRoomNumber: booking.MeetingRoomNumber });
        if (room) {
            room.status = 'available'; // เปลี่ยนสถานะห้องประชุม
            await room.save(); // บันทึกการเปลี่ยนแปลง
        }

        // ลบการจองออกจากฐานข้อมูล
        await Booking.deleteOne({ MeetingRoomNumber: MeetingRoomNumber });

        res.status(200).json({ message: 'Room returned successfully' }); // ส่งข้อความยืนยันการคืนห้อง
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};


// ฟังก์ชันดึงข้อมูลผู้ใช้ทั้งหมด
exports.getUsers = async (req, res) => {
    try {
        const users = await User.find(); // ค้นหาผู้ใช้ทั้งหมด
        res.status(200).json(users); // ส่งข้อมูลผู้ใช้กลับไป
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};

// ฟังก์ชันดึงข้อมูลผู้ใช้ตาม ID
exports.getUserByID = async (req, res) => {
    try {
        const { id } = req.params; // ดึง id จากพารามิเตอร์
        const user = await User.findById(id); // ค้นหาผู้ใช้ตาม id
        if (!user) return res.status(404).json({ message: 'User not found' }); // ถ้าไม่พบผู้ใช้
        res.status(200).json(user); // ส่งข้อมูลผู้ใช้กลับไป
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};

// ฟังก์ชันอัปเดตข้อมูลผู้ใช้
exports.updateUser = async (req, res) => {
    try {
        const { id } = req.params; // ดึง id จากพารามิเตอร์
        const user = await User.findById(id); // ค้นหาผู้ใช้ตาม id
        if (!user) return res.status(404).json({ message: 'User not found' }); // ถ้าไม่พบผู้ใช้
        const update = req.body; // ข้อมูลที่ต้องการอัปเดต
        Object.assign(user, update); // อัปเดตข้อมูลผู้ใช้
        const updatedUser = await user.save(); // บันทึกการอัปเดต
        res.json(updatedUser); // ส่งข้อมูลผู้ใช้ที่ถูกอัปเดตกลับไป
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};

// ฟังก์ชันลบผู้ใช้
exports.deleteUser = async (req, res) => {
    try {
        const { id } = req.params; // ดึง id จากพารามิเตอร์
        const user = await User.findById(id); // ค้นหาผู้ใช้ตาม id
        if (!user) return res.status(404).json({ message: 'User not found' }); // ถ้าไม่พบผู้ใช้
        await User.findByIdAndDelete(id); // ลบผู้ใช้
        res.json({ message: 'User deleted' }); // ส่งข้อความยืนยันการลบกลับไป
    } catch (err) {
        res.status(500).json({ message: err.message }); // ส่งข้อความผิดพลาด
    }
};

// ส่งออกฟังก์ชัน
module.exports = {
    addRoom: exports.addRoom,
    bookingRoom: exports.bookingRoom,
    checkRoomStatus: exports.checkRoomStatus,
    getBookings: exports.getBookings,
    approveBooking: exports.approveBooking,
    returnRoom: exports.returnRoom,
    getUsers: exports.getUsers,
    getUserByID: exports.getUserByID,
    updateUser: exports.updateUser,
    deleteUser: exports.deleteUser
};
