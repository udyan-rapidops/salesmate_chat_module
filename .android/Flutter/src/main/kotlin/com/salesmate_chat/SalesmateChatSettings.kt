package com.salesmate_chat


class SalesmateChatSettings(
    var workspaceId: String,
    var appKey: String,
    var tenantId: String,
    var environment: Environment = Environment.PRODUCTION,
) {

    fun toMap(): Map<String, String> = mapOf(
        "workspaceId" to workspaceId,
        "appKey" to appKey,
        "tenantId" to tenantId,
        "environment" to environment.value
    )
}