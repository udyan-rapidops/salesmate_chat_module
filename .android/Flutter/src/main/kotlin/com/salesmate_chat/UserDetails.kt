package com.salesmate_chat

class UserDetails(
    var email: String,
    var firstName: String,
    var lastName: String,
    var userHash: String,
) {

    fun toMap(): Map<String, String> = mapOf(
        "email" to email, "firstName" to firstName, "lastName" to lastName, "userHash" to userHash
    )
}