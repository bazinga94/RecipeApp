//
//  Retry.swift
//  Recipe
//
//  Created by Jongho Lee on 5/15/25.
//

func retry<T>(
	times: Int,
	delay: UInt64 = 500_000_000, // 0.5s
	operation: @escaping () async throws -> T
) async throws -> T {
	for attempt in 1...times {
		do {
			return try await operation()
		} catch {
			if attempt == times { throw error }
			try await Task.sleep(nanoseconds: delay)
		}
	}
	fatalError("Unreachable")
}
