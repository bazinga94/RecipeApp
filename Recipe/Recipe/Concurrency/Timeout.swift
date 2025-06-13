//
//  Timeout.swift
//  Recipe
//
//  Created by Jongho Lee on 5/15/25.
//

enum TimeoutError: Error {
	case timedOut
}

func withTimeout<T: Sendable>(
	seconds: Double,
	operation: @Sendable @escaping () async throws -> T
) async throws -> T {
	try await withThrowingTaskGroup(of: T.self) { group in
		// 1. Execute task
		group.addTask {
			return try await operation()
		}

		// 2. Timeout task
		group.addTask {
			try await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
			throw TimeoutError.timedOut
		}

		// 3. Return only the first finished task
		let result = try await group.next()!
		group.cancelAll()  // Cancel another task
		return result
	}
}
