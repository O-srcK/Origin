import java.io.*;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        System.out.println("Enter command ([1] [2 1] etc):");
        Scanner in = new Scanner(System.in);
        String input = in.nextLine();

        // Example, for demo: Run Opener.ps1 using user input
        try {
            ProcessBuilder pb = new ProcessBuilder("powershell.exe", "-ExecutionPolicy", "Bypass", "-File", "Opener.ps1",
                    "1", input, "", "");
            pb.inheritIO(); // Show output
            pb.start().waitFor();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
