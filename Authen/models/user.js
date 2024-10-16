const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
    id: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    firstname: { type: String, required: true },
    lastname: { type: String, required: true },
    faculty: { type: String, required: true },
    phone: { type: String, required: true },
    roomNum: { type: String, required: true },
    role: {
        type: String,
        enum: ['user', 'admin'], // กำหนดบทบาทผู้ใช้
        default: 'user'
    }
}, { timestamps: true });

module.exports = mongoose.model("User", userSchema);
