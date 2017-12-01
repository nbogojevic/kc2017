package nb.kubecon;

import java.util.Collections;
import java.util.Properties;
import org.apache.kafka.clients.admin.AdminClientConfig;
import org.apache.kafka.clients.consumer.Consumer;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.common.config.SaslConfigs;
import org.apache.kafka.common.serialization.LongDeserializer;
import org.apache.kafka.common.serialization.StringDeserializer;

public class KafkaConsumerSample {
  private static Consumer<Long, String> createConsumer() {
    Properties props = new Properties();
    props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, "kafka:9092");
    props.put(ConsumerConfig.CLIENT_ID_CONFIG, "KafkaConsumerSample");
    props.put(ConsumerConfig.GROUP_ID_CONFIG, "KafkaConsumerSample");
    props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, LongDeserializer.class.getName());
    props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class.getName());
    if (System.getenv().get("USE_ACL") != null) {
      props.setProperty(AdminClientConfig.SECURITY_PROTOCOL_CONFIG, "SASL_PLAINTEXT");
      props.setProperty(SaslConfigs.SASL_MECHANISM, "PLAIN");      
    }
    
    Consumer<Long, String> consumer = new KafkaConsumer<>(props);
    consumer.subscribe(Collections.singletonList("sample-topic"));
    return consumer;
  }

  static void runConsumer() throws Exception {
    final Consumer<Long, String> consumer = createConsumer();

    try {
      while (true) {
          final ConsumerRecords<Long, String> consumerRecords =
                  consumer.poll(1000);

          if (consumerRecords.count()==0) {
            continue;
          }

          consumerRecords.forEach(record -> {
              System.out.printf("Consumer Record:(%d, %s, %d, %d)\n",
                      record.key(), record.value(),
                      record.partition(), record.offset());
          });

          consumer.commitAsync();
      } 
    } finally {
      consumer.close();
    }
  }

  public static void main(String[] args) throws Exception {
    runConsumer();
  }
}
