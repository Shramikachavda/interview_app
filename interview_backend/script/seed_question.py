from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from datetime import datetime, timezone

import sys
import os

# Add the project root directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from models.models import Base, QuestionBank, QuestionType, DifficultyLevel




# Database setup
DATABASE_URL = "sqlite:///interview.db"
engine = create_engine(DATABASE_URL, connect_args={"check_same_thread": False})
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# List of questions: 10 per type (hr, coding, sql, conceptual) per difficulty (easy, medium, hard)
questions = [
    # HR Easy Questions (10)
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Tell me about yourself and your background.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Keep it concise", "Highlight relevant experience and skills"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What are your strengths?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Focus on job-relevant strengths", "Provide examples"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Why do you want this job?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Align with company values", "Show enthusiasm"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "How do you handle stress?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Mention specific techniques", "Stay positive"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Describe a time you worked in a team.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Highlight collaboration", "Mention your contribution"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What motivates you to work?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Be honest", "Connect to job role"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "How do you stay organized?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Mention tools like planners or apps", "Discuss prioritization"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What are your career goals?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Align with the role", "Show ambition"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Describe a time you showed initiative.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Use a specific example", "Highlight impact"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "How do you handle feedback?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Show openness", "Mention learning from feedback"]
        }
    },
    # HR Medium Questions (10)
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Describe a time when you had to work with a difficult team member. How did you handle it?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Use the STAR method", "Focus on conflict resolution"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "How do you prioritize tasks when working on multiple projects?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Discuss time management strategies", "Mention tools like to-do lists"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Tell me about a time you led a project.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Use STAR method", "Highlight leadership skills"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "How do you handle tight deadlines?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Discuss planning", "Mention stress management"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Describe a time you resolved a conflict at work.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Use STAR method", "Show diplomacy"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "How do you adapt to change in the workplace?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Provide an example", "Show flexibility"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Tell me about a time you exceeded expectations.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Use specific metrics", "Highlight impact"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "How do you ensure clear communication with your team?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Mention tools or methods", "Show clarity"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Describe a time you mentored a colleague.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Show leadership", "Highlight outcome"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "How do you balance quality and speed in your work?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Discuss prioritization", "Show efficiency"]
        }
    },
    # HR Hard Questions (10)
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Describe a situation where you failed to meet a deadline. What did you learn?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Be honest", "Focus on lessons learned"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Tell me about a time you managed a high-stakes project.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Use STAR method", "Highlight risk management"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "How do you handle ethical dilemmas at work?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Show integrity", "Provide an example"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Describe a time you turned around an underperforming team.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Show leadership", "Highlight results"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "How do you influence stakeholders with differing priorities?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Show persuasion skills", "Mention collaboration"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Tell me about a time you implemented a major change.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Use STAR method", "Show change management"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "How do you handle a situation where you disagree with your manager?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Show professionalism", "Highlight communication"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Describe a time you had to make a tough decision with limited information.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Show decision-making skills", "Highlight outcome"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "How do you manage remote or distributed teams?",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Mention tools", "Show leadership"]
        }
    },
    {
        "type": QuestionType.hr,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Tell me about a time you improved a process significantly.",
            "test_cases": [],
            "solution": "N/A",
            "hints": ["Use metrics", "Show impact"]
        }
    },
    # Coding Easy Questions (10)
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to check if a number is prime.",
            "test_cases": [
                {"input": "5", "expected_output": "True"},
                {"input": "4", "expected_output": "False"},
                {"input": "1", "expected_output": "False"}
            ],
            "solution": "def is_prime(n): if n < 2: return False; for i in range(2, int(n**0.5) + 1): if n % i == 0: return False; return True",
            "hints": ["Check divisibility up to square root of n", "Handle edge cases like 1"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to reverse a string.",
            "test_cases": [
                {"input": '"hello"', "expected_output": '"olleh"'},
                {"input": '"Python"', "expected_output": '"nohtyP"'}
            ],
            "solution": "def reverse_string(s): return s[::-1]",
            "hints": ["Use string slicing", "Handle empty strings"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to find the factorial of a number.",
            "test_cases": [
                {"input": "5", "expected_output": "120"},
                {"input": "0", "expected_output": "1"}
            ],
            "solution": "def factorial(n): return 1 if n == 0 else n * factorial(n-1)",
            "hints": ["Use recursion or iteration", "Handle base case"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to check if a string is a palindrome.",
            "test_cases": [
                {"input": '"racecar"', "expected_output": "True"},
                {"input": '"hello"', "expected_output": "False"}
            ],
            "solution": "def is_palindrome(s): return s == s[::-1]",
            "hints": ["Compare string with its reverse", "Ignore case if needed"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to find the sum of an array.",
            "test_cases": [
                {"input": "[1, 2, 3]", "expected_output": "6"},
                {"input": "[]", "expected_output": "0"}
            ],
            "solution": "def array_sum(arr): return sum(arr)",
            "hints": ["Use built-in sum()", "Handle empty arrays"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to find the maximum element in an array.",
            "test_cases": [
                {"input": "[1, 5, 3]", "expected_output": "5"},
                {"input": "[-1, -5]", "expected_output": "-1"}
            ],
            "solution": "def find_max(arr): return max(arr) if arr else None",
            "hints": ["Use built-in max()", "Handle empty arrays"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to check if two strings are anagrams.",
            "test_cases": [
                {"input": '"listen", "silent"', "expected_output": "True"},
                {"input": '"hello", "world"', "expected_output": "False"}
            ],
            "solution": "def are_anagrams(s1, s2): return sorted(s1) == sorted(s2)",
            "hints": ["Sort both strings", "Compare sorted results"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to count occurrences of an element in an array.",
            "test_cases": [
                {"input": "[1, 2, 2, 3], 2", "expected_output": "2"},
                {"input": "[1, 3], 4", "expected_output": "0"}
            ],
            "solution": "def count_occurrences(arr, x): return arr.count(x)",
            "hints": ["Use list.count()", "Handle missing elements"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to remove duplicates from an array.",
            "test_cases": [
                {"input": "[1, 2, 2, 3]", "expected_output": "[1, 2, 3]"},
                {"input": "[1, 1, 1]", "expected_output": "[1]"}
            ],
            "solution": "def remove_duplicates(arr): return list(dict.fromkeys(arr))",
            "hints": ["Use set or dict", "Preserve order if needed"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write a Python function to check if a number is even.",
            "test_cases": [
                {"input": "4", "expected_output": "True"},
                {"input": "3", "expected_output": "False"}
            ],
            "solution": "def is_even(n): return n % 2 == 0",
            "hints": ["Use modulo operator", "Handle negative numbers"]
        }
    },
    # Coding Medium Questions (10)
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to find the longest common prefix among a list of strings.",
            "test_cases": [
                {"input": '["flower", "flow", "flight"]', "expected_output": '"fl"'},
                {"input": '["dog", "racecar", "car"]', "expected_output": '""'}
            ],
            "solution": "def longest_common_prefix(strs): if not strs: return ''; prefix = strs[0]; for s in strs[1:]: while s[:len(prefix)] != prefix: prefix = prefix[:-1]; if not prefix: return ''; return prefix",
            "hints": ["Compare characters", "Shorten prefix"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to merge two sorted lists.",
            "test_cases": [
                {"input": "[1, 3], [2, 4]", "expected_output": "[1, 2, 3, 4]"},
                {"input": "[], [1]", "expected_output": "[1]"}
            ],
            "solution": "def merge_sorted_lists(l1, l2): result = []; i = j = 0; while i < len(l1) and j < len(l2): if l1[i] < l2[j]: result.append(l1[i]); i += 1; else: result.append(l2[j]); j += 1; return result + l1[i:] + l2[j:]",
            "hints": ["Use two pointers", "Handle remaining elements"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to find the intersection of two arrays.",
            "test_cases": [
                {"input": "[1, 2, 2, 1], [2, 2]", "expected_output": "[2, 2]"},
                {"input": "[1, 2], [3, 4]", "expected_output": "[]"}
            ],
            "solution": "def intersect_arrays(arr1, arr2): return [x for x in arr1 if x in arr2]",
            "hints": ["Use list comprehension", "Handle duplicates"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to rotate an array by k steps.",
            "test_cases": [
                {"input": "[1, 2, 3, 4, 5], 2", "expected_output": "[4, 5, 1, 2, 3]"},
                {"input": "[1], 1", "expected_output": "[1]"}
            ],
            "solution": "def rotate_array(arr, k): k = k % len(arr); return arr[-k:] + arr[:-k]",
            "hints": ["Use slicing", "Handle k > len(arr)"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to find the first missing positive integer.",
            "test_cases": [
                {"input": "[1, 2, 0]", "expected_output": "3"},
                {"input": "[3, 4, -1, 1]", "expected_output": "2"}
            ],
            "solution": "def first_missing_positive(nums): n = len(nums); for i in range(n): while 1 <= nums[i] <= n and nums[nums[i] - 1] != nums[i]: nums[nums[i] - 1], nums[i] = nums[i], nums[nums[i] - 1]; for i in range(n): if nums[i] != i + 1: return i + 1; return n + 1",
            "hints": ["Use array as hash table", "Ignore non-positive numbers"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to group anagrams in a list of strings.",
            "test_cases": [
                {"input": '["eat", "tea", "tan", "ate", "nat", "bat"]', "expected_output": '[["eat", "tea", "ate"], ["tan", "nat"], ["bat"]]'},
                {"input": '[""]', "expected_output": '[[""]]'}
            ],
            "solution": "def group_anagrams(strs): d = {}; for s in strs: key = ''.join(sorted(s)); d[key] = d.get(key, []) + [s]; return list(d.values())",
            "hints": ["Use sorted string as key", "Use dictionary"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to implement a stack using two queues.",
            "test_cases": [
                {"input": "push(1), push(2), pop()", "expected_output": "2"},
                {"input": "push(1), pop()", "expected_output": "1"}
            ],
            "solution": "class Stack: def __init__(self): self.q1 = []; self.q2 = []; def push(self, x): self.q2.append(x); while self.q1: self.q2.append(self.q1.pop(0)); self.q1, self.q2 = self.q2, self.q1; def pop(self): return self.q1.pop(0)",
            "hints": ["Use queues to simulate LIFO", "Swap queues"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to check for valid parentheses.",
            "test_cases": [
                {"input": '"()"', "expected_output": "True"},
                {"input": '"(]"', "expected_output": "False"}
            ],
            "solution": "def is_valid(s): stack = []; for c in s: if c in '([{': stack.append(c); elif c in ')]}' and (not stack or stack.pop() != '([{'[')]}'.index(c)]): return False; return not stack",
            "hints": ["Use stack", "Match opening and closing brackets"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to find the kth largest element in an array.",
            "test_cases": [
                {"input": "[3, 2, 1, 5, 6, 4], 2", "expected_output": "5"},
                {"input": "[3, 2, 3, 1], 1", "expected_output": "3"}
            ],
            "solution": "def find_kth_largest(nums, k): return sorted(nums)[-k]",
            "hints": ["Sort array", "Access kth element from end"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write a Python function to implement binary search.",
            "test_cases": [
                {"input": "[1, 2, 3, 4, 5], 3", "expected_output": "2"},
                {"input": "[1, 2, 3], 6", "expected_output": "-1"}
            ],
            "solution": "def binary_search(arr, target): left, right = 0, len(arr)-1; while left <= right: mid = (left + right) // 2; if arr[mid] == target: return mid; elif arr[mid] < target: left = mid + 1; else: right = mid - 1; return -1",
            "hints": ["Use divide and conquer", "Assume sorted array"]
        }
    },
    # Coding Hard Questions (10)
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to solve the N-Queens problem and return all possible solutions.",
            "test_cases": [
                {"input": "4", "expected_output": '[[".Q..","...Q","Q...","..Q."],["..Q.","Q...","...Q",".Q.."]]'},
                {"input": "1", "expected_output": '[["Q"]]'}
            ],
            "solution": "def solve_n_queens(n): ... # (complex backtracking solution omitted for brevity)",
            "hints": ["Use backtracking", "Check valid placements"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to find the median of two sorted arrays.",
            "test_cases": [
                {"input": "[1, 3], [2]", "expected_output": "2.0"},
                {"input": "[1, 2], [3, 4]", "expected_output": "2.5"}
            ],
            "solution": "def find_median_sorted_arrays(nums1, nums2): ... # (complex solution omitted)",
            "hints": ["Use binary search", "Handle odd/even total length"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to implement regular expression matching.",
            "test_cases": [
                {"input": '"aa", "a*"', "expected_output": "True"},
                {"input": '"aa", "a"', "expected_output": "False"}
            ],
            "solution": "def is_match(s, p): ... # (complex dynamic programming solution omitted)",
            "hints": ["Use dynamic programming", "Handle * and ."]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to merge k sorted lists.",
            "test_cases": [
                {"input": "[[1,4,5],[1,3,4],[2,6]]", "expected_output": "[1,1,2,3,4,4,5,6]"},
                {"input": "[]", "expected_output": "[]"}
            ],
            "solution": "def merge_k_lists(lists): ... # (heap-based solution omitted)",
            "hints": ["Use min heap", "Handle empty lists"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to find the longest valid parentheses substring.",
            "test_cases": [
                {"input": '"(()"', "expected_output": "2"},
                {"input": '")()())"', "expected_output": "4"}
            ],
            "solution": "def longest_valid_parentheses(s): ... # (stack-based solution omitted)",
            "hints": ["Use stack", "Track valid substrings"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to solve the sudoku puzzle.",
            "test_cases": [
                {"input": '[["5","3",".",".","7",".",".",".","."],...]', "expected_output": "solved board"},
                {"input": '[[".",".",".",".",".",".",".",".","."],...]', "expected_output": "solved board"}
            ],
            "solution": "def solve_sudoku(board): ... # (backtracking solution omitted)",
            "hints": ["Use backtracking", "Check valid placements"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to find the shortest path in a weighted graph.",
            "test_cases": [
                {"input": "graph, start, end", "expected_output": "path"},
                {"input": "empty graph", "expected_output": "[]"}
            ],
            "solution": "def shortest_path(graph, start, end): ... # (Dijkstra's algorithm omitted)",
            "hints": ["Use Dijkstra’s algorithm", "Handle disconnected graphs"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to implement LRU cache.",
            "test_cases": [
                {"input": "capacity=2, operations", "expected_output": "results"},
                {"input": "capacity=1, operations", "expected_output": "results"}
            ],
            "solution": "class LRUCache: ... # (hash map + doubly linked list omitted)",
            "hints": ["Use hash map and linked list", "Track least recently used"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to find the minimum window substring containing all characters.",
            "test_cases": [
                {"input": '"ADOBECODEBANC", "ABC"', "expected_output": '"BANC"'},
                {"input": '"a", "a"', "expected_output": '"a"'}
            ],
            "solution": "def min_window(s, t): ... # (sliding window solution omitted)",
            "hints": ["Use sliding window", "Track character counts"]
        }
    },
    {
        "type": QuestionType.coding,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write a Python function to find the longest palindromic substring.",
            "test_cases": [
                {"input": '"babad"', "expected_output": '"bab"'},
                {"input": '"cbbd"', "expected_output": '"bb"'}
            ],
            "solution": "def longest_palindrome(s): ... # (expand around center omitted)",
            "hints": ["Expand around center", "Check odd/even lengths"]
        }
    },
    # SQL Easy Questions (10)
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to select all employees from the employees table where salary is greater than 50000.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT); INSERT INTO employees VALUES (1, 'Alice', 60000), (2, 'Bob', 40000);", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM employees WHERE salary > 50000;",
            "hints": ["Use WHERE clause", "Check column names"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to count the number of employees in each department.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), dept_id INT); INSERT INTO employees VALUES (1, 'Alice', 1), (2, 'Bob', 1), (3, 'Charlie', 2);", "expected_output": "1|2\n2|1"}
            ],
            "solution": "SELECT dept_id, COUNT(*) FROM employees GROUP BY dept_id;",
            "hints": ["Use GROUP BY", "Use COUNT()"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to find employees with a specific job title.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), job_title VARCHAR(50)); INSERT INTO employees VALUES (1, 'Alice', 'Engineer'), (2, 'Bob', 'Manager');", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM employees WHERE job_title = 'Engineer';",
            "hints": ["Use WHERE clause", "Match exact job title"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to list all departments.",
            "test_cases": [
                {"input": "CREATE TABLE departments (id INT, name VARCHAR(50)); INSERT INTO departments VALUES (1, 'HR'), (2, 'IT');", "expected_output": "HR\nIT"}
            ],
            "solution": "SELECT name FROM departments;",
            "hints": ["Simple SELECT", "No filtering needed"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to find the highest salary in the employees table.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT); INSERT INTO employees VALUES (1, 'Alice', 60000), (2, 'Bob', 70000);", "expected_output": "70000"}
            ],
            "solution": "SELECT MAX(salary) FROM employees;",
            "hints": ["Use MAX()", "Handle empty table"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to select employees hired after a specific date.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), hire_date DATE); INSERT INTO employees VALUES (1, 'Alice', '2023-01-01'), (2, 'Bob', '2022-01-01');", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM employees WHERE hire_date > '2022-12-31';",
            "hints": ["Use WHERE clause", "Format date correctly"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to list employees in alphabetical order.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50)); INSERT INTO employees VALUES (1, 'Bob'), (2, 'Alice');", "expected_output": "Alice\nBob"}
            ],
            "solution": "SELECT name FROM employees ORDER BY name;",
            "hints": ["Use ORDER BY", "Default is ascending"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to find employees in a specific city.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), city VARCHAR(50)); INSERT INTO employees VALUES (1, 'Alice', 'New York'), (2, 'Bob', 'London');", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM employees WHERE city = 'New York';",
            "hints": ["Use WHERE clause", "Match exact city"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to count total employees.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50)); INSERT INTO employees VALUES (1, 'Alice'), (2, 'Bob');", "expected_output": "2"}
            ],
            "solution": "SELECT COUNT(*) FROM employees;",
            "hints": ["Use COUNT()", "No filtering needed"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Write an SQL query to find employees with salary between 40000 and 60000.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT); INSERT INTO employees VALUES (1, 'Alice', 50000), (2, 'Bob', 70000);", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM employees WHERE salary BETWEEN 40000 AND 60000;",
            "hints": ["Use BETWEEN", "Inclusive range"]
        }
    },
    # SQL Medium Questions (10)
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find the second highest salary from the employees table.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT); INSERT INTO employees VALUES (1, 'Alice', 60000), (2, 'Bob', 70000), (3, 'Charlie', 50000);", "expected_output": "60000"}
            ],
            "solution": "SELECT MAX(salary) FROM employees WHERE salary < (SELECT MAX(salary) FROM employees);",
            "hints": ["Use subquery", "Exclude highest salary"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find employees who joined in the last year.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), hire_date DATE); INSERT INTO employees VALUES (1, 'Alice', '2023-06-01'), (2, 'Bob', '2022-01-01');", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM employees WHERE hire_date >= date('now', '-1 year');",
            "hints": ["Use date functions", "Check last 12 months"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find departments with more than 5 employees.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), dept_id INT); INSERT INTO employees VALUES (1, 'Alice', 1), (2, 'Bob', 1), (3, 'Charlie', 1), (4, 'Dave', 1), (5, 'Eve', 1), (6, 'Frank', 1);", "expected_output": "1"}
            ],
            "solution": "SELECT dept_id FROM employees GROUP BY dept_id HAVING COUNT(*) > 5;",
            "hints": ["Use GROUP BY and HAVING", "Count employees"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find employees with the same salary.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT); INSERT INTO employees VALUES (1, 'Alice', 50000), (2, 'Bob', 50000), (3, 'Charlie', 60000);", "expected_output": "Alice\nBob"}
            ],
            "solution": "SELECT name FROM employees WHERE salary IN (SELECT salary FROM employees GROUP BY salary HAVING COUNT(*) > 1);",
            "hints": ["Use subquery with GROUP BY", "Check for duplicates"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to list employees and their department names.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), dept_id INT); CREATE TABLE departments (id INT, name VARCHAR(50)); INSERT INTO employees VALUES (1, 'Alice', 1); INSERT INTO departments VALUES (1, 'HR');", "expected_output": "Alice|HR"}
            ],
            "solution": "SELECT e.name, d.name FROM employees e JOIN departments d ON e.dept_id = d.id;",
            "hints": ["Use JOIN", "Match dept_id"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find the top 3 salaries in each department.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT, dept_id INT); INSERT INTO employees VALUES (1, 'Alice', 60000, 1), (2, 'Bob', 70000, 1), (3, 'Charlie', 50000, 1);", "expected_output": "Bob\nAlice"}
            ],
            "solution": "SELECT name FROM (SELECT name, salary, dept_id, DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as rnk FROM employees) WHERE rnk <= 3;",
            "hints": ["Use window function", "Rank by salary"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find employees without a manager.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), manager_id INT); INSERT INTO employees VALUES (1, 'Alice', NULL), (2, 'Bob', 1);", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM employees WHERE manager_id IS NULL;",
            "hints": ["Check for NULL", "Simple WHERE clause"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find the average salary per department.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT, dept_id INT); INSERT INTO employees VALUES (1, 'Alice', 60000, 1), (2, 'Bob', 70000, 1);", "expected_output": "1|65000"}
            ],
            "solution": "SELECT dept_id, AVG(salary) FROM employees GROUP BY dept_id;",
            "hints": ["Use GROUP BY", "Use AVG()"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find employees with salaries above their department average.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT, dept_id INT); INSERT INTO employees VALUES (1, 'Alice', 60000, 1), (2, 'Bob', 70000, 1), (3, 'Charlie', 50000, 1);", "expected_output": "Bob"}
            ],
            "solution": "SELECT e.name FROM employees e JOIN (SELECT dept_id, AVG(salary) as avg_salary FROM employees GROUP BY dept_id) d ON e.dept_id = d.dept_id WHERE e.salary > d.avg_salary;",
            "hints": ["Use subquery for average", "Join with original table"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Write an SQL query to find duplicate employee records by email.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), email VARCHAR(50)); INSERT INTO employees VALUES (1, 'Alice', 'a@example.com'), (2, 'Bob', 'a@example.com');", "expected_output": "a@example.com"}
            ],
            "solution": "SELECT email FROM employees GROUP BY email HAVING COUNT(*) > 1;",
            "hints": ["Use GROUP BY", "Check for count > 1"]
        }
    },
    # SQL Hard Questions (10)
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to find employees who earn more than their managers.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT, manager_id INT); INSERT INTO employees VALUES (1, 'Alice', 90000, NULL), (2, 'Bob', 80000, 1), (3, 'Charlie', 95000, 1);", "expected_output": "Charlie"}
            ],
            "solution": "SELECT e1.name FROM employees e1 JOIN employees e2 ON e1.manager_id = e2.id WHERE e1.salary > e2.salary;",
            "hints": ["Use self-join", "Compare salaries"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to find the nth highest salary in the employees table.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT); INSERT INTO employees VALUES (1, 'Alice', 60000), (2, 'Bob', 70000), (3, 'Charlie', 50000); n=2", "expected_output": "60000"}
            ],
            "solution": "SELECT DISTINCT salary FROM employees ORDER BY salary DESC LIMIT 1 OFFSET :n-1;",
            "hints": ["Use LIMIT and OFFSET", "Handle duplicates"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to find employees who are in the top 10% by salary.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT); INSERT INTO employees VALUES (1, 'Alice', 60000), (2, 'Bob', 90000), (3, 'Charlie', 80000);", "expected_output": "Bob"}
            ],
            "solution": "SELECT name FROM (SELECT name, salary, NTILE(10) OVER (ORDER BY salary DESC) as ntile FROM employees) WHERE ntile = 1;",
            "hints": ["Use NTILE", "Order by salary"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to find the longest serving employee in each department.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), dept_id INT, hire_date DATE); INSERT INTO employees VALUES (1, 'Alice', 1, '2020-01-01'), (2, 'Bob', 1, '2021-01-01');", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM (SELECT name, dept_id, hire_date, RANK() OVER (PARTITION BY dept_id ORDER BY hire_date) as rnk FROM employees) WHERE rnk = 1;",
            "hints": ["Use window function", "Rank by hire_date"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to find gaps in employee IDs.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT); INSERT INTO employees VALUES (1), (2), (4), (6);", "expected_output": "3\n5"}
            ],
            "solution": "SELECT id + 1 AS gap_start FROM employees e1 WHERE NOT EXISTS (SELECT 1 FROM employees e2 WHERE e2.id = e1.id + 1) AND id < (SELECT MAX(id) FROM employees);",
            "hints": ["Use subquery", "Check for missing IDs"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to find employees with consecutive absences.",
            "test_cases": [
                {"input": "CREATE TABLE attendance (employee_id INT, absence_date DATE); INSERT INTO attendance VALUES (1, '2023-01-01'), (1, '2023-01-02');", "expected_output": "1"}
            ],
            "solution": "SELECT DISTINCT employee_id FROM (SELECT employee_id, absence_date, LAG(absence_date) OVER (PARTITION BY employee_id ORDER BY absence_date) as prev_date FROM attendance) WHERE absence_date = prev_date + 1;",
            "hints": ["Use LAG()", "Check consecutive dates"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to find employees with the same manager and department.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), dept_id INT, manager_id INT); INSERT INTO employees VALUES (1, 'Alice', 1, 3), (2, 'Bob', 1, 3);", "expected_output": "Alice\nBob"}
            ],
            "solution": "SELECT e1.name FROM employees e1 JOIN employees e2 ON e1.dept_id = e2.dept_id AND e1.manager_id = e2.manager_id AND e1.id != e2.id;",
            "hints": ["Use self-join", "Match dept_id and manager_id"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to calculate running total of salaries by department.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT, dept_id INT); INSERT INTO employees VALUES (1, 'Alice', 60000, 1), (2, 'Bob', 70000, 1);", "expected_output": "Alice|60000\nBob|130000"}
            ],
            "solution": "SELECT name, SUM(salary) OVER (PARTITION BY dept_id ORDER BY id) as running_total FROM employees;",
            "hints": ["Use window function", "Sum by department"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to find employees whose salary rank is 2 in their department.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT, dept_id INT); INSERT INTO employees VALUES (1, 'Alice', 60000, 1), (2, 'Bob', 70000, 1), (3, 'Charlie', 50000, 1);", "expected_output": "Alice"}
            ],
            "solution": "SELECT name FROM (SELECT name, dept_id, DENSE_RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as rnk FROM employees) WHERE rnk = 2;",
            "hints": ["Use DENSE_RANK()", "Partition by department"]
        }
    },
    {
        "type": QuestionType.sql,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Write an SQL query to pivot employee data by department and salary range.",
            "test_cases": [
                {"input": "CREATE TABLE employees (id INT, name VARCHAR(50), salary INT, dept_id INT); INSERT INTO employees VALUES (1, 'Alice', 60000, 1), (2, 'Bob', 90000, 1);", "expected_output": "pivot table"}
            ],
            "solution": "SELECT * FROM (SELECT dept_id, CASE WHEN salary < 70000 THEN 'Low' ELSE 'High' END as salary_range, COUNT(*) as cnt FROM employees GROUP BY dept_id, salary_range) PIVOT (SUM(cnt) FOR salary_range IN ('Low', 'High'));",
            "hints": ["Use CASE for ranges", "Use PIVOT if supported"]
        }
    },
    # Conceptual Easy Questions (10)
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What is the difference between a stack and a queue?",
            "test_cases": [],
            "solution": "Stack is LIFO (Last In, First Out); Queue is FIFO (First In, First Out).",
            "hints": ["Mention LIFO vs FIFO", "Give examples"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Explain what an API is.",
            "test_cases": [],
            "solution": "An API (Application Programming Interface) allows different software systems to communicate with each other.",
            "hints": ["Mention communication", "Give an example"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What is object-oriented programming?",
            "test_cases": [],
            "solution": "OOP is a programming paradigm based on objects, encapsulation, inheritance, and polymorphism.",
            "hints": ["Mention key principles", "Give examples"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What is a database index?",
            "test_cases": [],
            "solution": "A database index is a data structure that improves the speed of data retrieval operations.",
            "hints": ["Mention performance", "Compare to book index"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "Explain the difference between HTTP and HTTPS.",
            "test_cases": [],
            "solution": "HTTP is unsecured; HTTPS uses SSL/TLS for secure communication.",
            "hints": ["Mention security", "Explain encryption"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What is version control?",
            "test_cases": [],
            "solution": "Version control tracks changes to code, enabling collaboration and history management.",
            "hints": ["Mention Git", "Discuss collaboration"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What is a primary key in a database?",
            "test_cases": [],
            "solution": "A primary key uniquely identifies each record in a table.",
            "hints": ["Mention uniqueness", "Give example"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What is the purpose of a constructor in programming?",
            "test_cases": [],
            "solution": "A constructor initializes an object when it is created.",
            "hints": ["Mention initialization", "Give example in Python"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What is a loop in programming?",
            "test_cases": [],
            "solution": "A loop repeatedly executes a block of code until a condition is met.",
            "hints": ["Mention for/while loops", "Give example"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.easy,
        "question_data": {
            "question_text": "What is the difference between a list and a tuple in Python?",
            "test_cases": [],
            "solution": "Lists are mutable; tuples are immutable.",
            "hints": ["Mention mutability", "Give use cases"]
        }
    },
    # Conceptual Medium Questions (10)
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Explain the difference between monolithic and microservices architecture.",
            "test_cases": [],
            "solution": "Monolithic is a single unit; microservices are independent, modular services.",
            "hints": ["Mention scalability", "Discuss deployment"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "What is normalization in databases?",
            "test_cases": [],
            "solution": "Normalization organizes data to reduce redundancy and improve integrity.",
            "hints": ["Mention normal forms", "Explain redundancy"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "What is a RESTful API?",
            "test_cases": [],
            "solution": "A RESTful API uses HTTP methods and stateless operations for communication.",
            "hints": ["Mention HTTP methods", "Explain statelessness"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Explain the difference between synchronous and asynchronous programming.",
            "test_cases": [],
            "solution": "Synchronous blocks until completion; asynchronous allows other tasks to run.",
            "hints": ["Mention async/await", "Give examples"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "What is a hash table and how does it work?",
            "test_cases": [],
            "solution": "A hash table maps keys to values using a hash function for fast lookup.",
            "hints": ["Mention hash function", "Discuss collisions"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "What is dependency injection?",
            "test_cases": [],
            "solution": "Dependency injection provides dependencies to a class externally.",
            "hints": ["Mention decoupling", "Give framework example"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "Explain the CAP theorem in distributed systems.",
            "test_cases": [],
            "solution": "CAP theorem states a system can only guarantee two of Consistency, Availability, Partition Tolerance.",
            "hints": ["Mention trade-offs", "Give examples"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "What is the difference between a process and a thread?",
            "test_cases": [],
            "solution": "A process is an independent program; a thread is a lightweight unit within a process.",
            "hints": ["Mention memory sharing", "Give examples"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "What is SQL injection and how to prevent it?",
            "test_cases": [],
            "solution": "SQL injection is a vulnerability where malicious SQL is injected; prevent with parameterized queries.",
            "hints": ["Mention parameterized queries", "Avoid string concatenation"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.medium,
        "question_data": {
            "question_text": "What is the purpose of a load balancer?",
            "test_cases": [],
            "solution": "A load balancer distributes traffic across servers to improve performance and reliability.",
            "hints": ["Mention scalability", "Discuss types"]
        }
    },
    # Conceptual Hard Questions (10)
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Explain how a distributed consensus algorithm like Raft works.",
            "test_cases": [],
            "solution": "Raft achieves consensus through leader election, log replication, and safety guarantees.",
            "hints": ["Mention leader election", "Discuss log replication"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "What is eventual consistency in distributed systems?",
            "test_cases": [],
            "solution": "Eventual consistency ensures all replicas converge to the same state over time.",
            "hints": ["Mention CAP theorem", "Give examples"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Explain the difference between horizontal and vertical scaling.",
            "test_cases": [],
            "solution": "Horizontal scaling adds more machines; vertical scaling increases machine resources.",
            "hints": ["Mention scalability", "Discuss trade-offs"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "What is a message queue and how is it used in distributed systems?",
            "test_cases": [],
            "solution": "A message queue enables asynchronous communication between services.",
            "hints": ["Mention decoupling", "Give examples like RabbitMQ"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Explain the concept of sharding in databases.",
            "test_cases": [],
            "solution": "Sharding splits a database into smaller, distributed parts for scalability.",
            "hints": ["Mention partitioning", "Discuss scalability"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "What is the difference between ACID and BASE properties in databases?",
            "test_cases": [],
            "solution": "ACID ensures reliability; BASE prioritizes availability and eventual consistency.",
            "hints": ["Mention trade-offs", "Give examples"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Explain how OAuth 2.0 works for authentication.",
            "test_cases": [],
            "solution": "OAuth 2.0 uses access tokens for secure, delegated access to resources.",
            "hints": ["Mention tokens", "Discuss flows"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "What is the difference between a B-tree and a binary search tree?",
            "test_cases": [],
            "solution": "B-tree is balanced, used in databases; BST is simpler, used in memory.",
            "hints": ["Mention balance", "Discuss use cases"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "Explain the concept of eventual consistency in NoSQL databases.",
            "test_cases": [],
            "solution": "Eventual consistency ensures all nodes eventually agree on data.",
            "hints": ["Mention CAP theorem", "Discuss trade-offs"]
        }
    },
    {
        "type": QuestionType.conceptual,
        "difficulty": DifficultyLevel.hard,
        "question_data": {
            "question_text": "What is a circuit breaker pattern in microservices?",
            "test_cases": [],
            "solution": "Circuit breaker prevents cascading failures by stopping requests to failing services.",
            "hints": ["Mention fault tolerance", "Discuss states"]
        }
    }
]

def insert_questions():
    db: Session = SessionLocal()
    try:
        # Check for existing questions to avoid duplicates
        existing_questions = db.query(QuestionBank).all()
        existing_texts = {q.question_data["question_text"] for q in existing_questions}

        inserted_count = 0
        for q in questions:
            if q["question_data"]["question_text"] not in existing_texts:
                db.add(QuestionBank(
                    type=q["type"],
                    difficulty=q["difficulty"],
                    question_data=q["question_data"],
                    created_at=datetime.now(timezone.utc)
                ))
                inserted_count += 1
            else:
                print(f"Skipping duplicate question: {q['question_data']['question_text']}")

        db.commit()
        print(f"✅ Successfully inserted {inserted_count} questions.")
    except Exception as e:
        db.rollback()
        print(f"❌ Error inserting questions: {str(e)}")
        raise
    finally:
        db.close()

if __name__ == "__main__":
    insert_questions()