from math import sin
import matplotlib.pyplot as plt
from algorithms import *
from datetime import datetime


def create_system_matrix(a1, a2, a3, size):
    matrix = [[0 for i in range(size)] for j in range(size)]
    for i in range(size):
        matrix[i][i] = a1
        if i < size - 1:
            matrix[i + 1][i] = a2
            matrix[i][i + 1] = a2
        if i < size - 2:
            matrix[i + 2][i] = a3
            matrix[i][i + 2] = a3

    return matrix


def plot(x, y, title, x_label, y_label, label, log=True):
    plt.plot(x, y, label=label)
    plt.title(title)
    plt.xlabel(x_label)
    plt.ylabel(y_label)
    plt.yscale('log' if log else 'linear')
    plt.legend()
    plt.show()


def analyze_iteration_methods():
    N = 934
    sm = create_system_matrix(a1=11,  a2=-1, a3=-1, size=N)
    b = [sin(n*7) for n in range(N)]
    residuum = 1e-9

    time = datetime.now()
    iter, err = solve_jacobi(a=Matrix(sm), b=Matrix.from_list(b), residuum=residuum)
    print("Jacobi method: ", (datetime.now() - time).total_seconds(), "s")

    plt.axhline(y=residuum, color='g', linestyle='--', label=f'Precision threshold')
    plt.axhline(y=1/residuum, color='r', linestyle='--', label=f'Error threshold')
    plt.plot(range(iter), err, label="Jacobi method")

    time = datetime.now()
    iter, err = solve_gauss_seidel(a=Matrix(sm), b=Matrix.from_list(b), residuum=residuum)
    print("Gauss-Seidel method: ", (datetime.now() - time).total_seconds(), "s")
    plot(range(iter), err, "Iteration methods", "Iterations", "Residual error", "Gauss-Seidel method")


def analyze_convergence():
    N = 934
    sm = create_system_matrix(a1=3, a2=-1, a3=-1, size=N)
    b = [sin(n * 7) for n in range(N)]
    residuum = 1e-9

    iter, err = solve_jacobi(a=Matrix(sm), b=Matrix.from_list(b), residuum=residuum)

    plt.axhline(y=residuum, color='g', linestyle='--', label=f'Precision threshold')
    plt.axhline(y=1 / residuum, color='r', linestyle='--', label=f'Error threshold')
    plt.plot(range(iter), err, label="Jacobi method")

    iter, err = solve_gauss_seidel(a=Matrix(sm), b=Matrix.from_list(b), residuum=residuum)
    plot(range(iter), err, "Convergence", "Iterations", "Residual error", "Gauss-Seidel method")


def analyze_factorization():
    N = 934
    sm = create_system_matrix(a1=3, a2=-1, a3=-1, size=N)
    b = [sin(n * 7) for n in range(N)]

    time = datetime.now()
    solution_vector, err = solve_factorization_lu(a=Matrix(sm), b=Matrix.from_list(b))
    print("Factorization LU method: ", (datetime.now() - time).total_seconds(), "s")
    print("Residual error: ", err)


def analyze_time():
    N = [100, 200, 300, 400, 500]
    time_jacobi = []
    time_gauss_seidel = []
    time_factorization = []
    for size in N:
        sm = create_system_matrix(a1=11, a2=-1, a3=-1, size=size)
        b = [sin(n * 7) for n in range(size)]

        time = datetime.now()
        solve_jacobi(a=Matrix(sm), b=Matrix.from_list(b), residuum=1e-9)
        time_jacobi.append((datetime.now() - time).total_seconds())

        time = datetime.now()
        solve_gauss_seidel(a=Matrix(sm), b=Matrix.from_list(b), residuum=1e-9)
        time_gauss_seidel.append((datetime.now() - time).total_seconds())

        time = datetime.now()
        solve_factorization_lu(a=Matrix(sm), b=Matrix.from_list(b))
        time_factorization.append((datetime.now() - time).total_seconds())

    plt.plot(N, time_jacobi, label="Jacobi method")
    plt.plot(N, time_gauss_seidel, label="Gauss-Seidel method")
    plot(N, time_factorization, "Time of execution", "Matrix size", "Time [s]", "Factorization LU method", log=False)


def main():
    # analyze_iteration_methods()
    # analyze_convergence()
    # analyze_factorization()
    analyze_time()


if __name__ == '__main__':
    main()
