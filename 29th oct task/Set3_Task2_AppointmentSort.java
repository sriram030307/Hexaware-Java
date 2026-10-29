import java.util.Arrays;
import java.util.Comparator;

public class Set3_Task2_AppointmentSort {
    static class Appt {
        String patient; int urgency, arrival;
        Appt(String patient, int urgency, int arrival) {
            this.patient = patient; this.urgency = urgency; this.arrival = arrival;
        }
    }
    public static void main(String[] args) {
        Appt[] appointments = {
            new Appt("P1", 2, 930), new Appt("P2", 1, 945), new Appt("P3", 1, 910)
        };
        Arrays.sort(appointments, Comparator.comparingInt((Appt a) -> a.urgency)
                                            .thenComparingInt(a -> a.arrival));
        for (Appt a : appointments)
            System.out.println(a.patient + " urgency=" + a.urgency + " arrival=" + a.arrival);
        System.out.println("Selection sort O(n^2); quicksort average O(n log n).");
    }
}
