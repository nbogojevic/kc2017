package nb.kubecon;

import java.util.Properties;
import org.apache.kafka.clients.admin.AdminClientConfig;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.config.SaslConfigs;
import org.apache.kafka.common.serialization.LongSerializer;
import org.apache.kafka.common.serialization.StringSerializer;

public class KafkaProducerSample {
  private static Producer<Long, String> createProducer() {
    Properties props = new Properties();
    props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:9092");
    props.put(ProducerConfig.CLIENT_ID_CONFIG, "KafkaProducerSample");
    props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, LongSerializer.class.getName());
    props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
    if (System.getenv().get("USE_ACL") != null) {
      props.setProperty(AdminClientConfig.SECURITY_PROTOCOL_CONFIG, "SASL_PLAINTEXT");
      props.setProperty(SaslConfigs.SASL_MECHANISM, "PLAIN");      
    }
    return new KafkaProducer<>(props);
  }

  static void runProducer(final int sendMessageCount) throws Exception {
    final Producer<Long, String> producer = createProducer();
    long time = System.currentTimeMillis();

    try {
      for (long index = time; index < time + sendMessageCount; index++) {
        final ProducerRecord<Long, String> record = new ProducerRecord<>("sample-topic", index,
            "Hello world " + index);

        RecordMetadata metadata = producer.send(record).get();

        long elapsedTime = System.currentTimeMillis() - time;
        System.out.printf("sent record(key=%s value=%s) " + "meta(partition=%d, offset=%d) time=%d\n", record.key(),
            record.value(), metadata.partition(), metadata.offset(), elapsedTime);
        Thread.sleep(1000);
      }
    } finally {
      producer.flush();
      producer.close();
    }
  }

  public static void main(String[] args) throws Exception {
    runProducer(10000);
  }
}
