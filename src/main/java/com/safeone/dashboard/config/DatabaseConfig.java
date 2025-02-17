package com.safeone.dashboard.config;

import org.apache.commons.dbcp2.BasicDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.jasypt.encryption.StringEncryptor;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;


@Configuration
@MapperScan(value = "com.safeone.dashboard.dao.**", sqlSessionFactoryRef = "sqlSessionFactory")
public class DatabaseConfig {
    @Value("${datasource.driverClassName}")
    private String DRIVER_CLASS_NAME;

    @Value("${datasource.username}")
    private String USERNAME;

    @Value("${datasource.password}")
    private String PASSWORD;

    @Value("${datasource.url}")
    private String DB_URL;

    @Value("${datasource.database}")
    private String DB_NAME;

    public static void main(String[] args) {
        System.out.println("jdbc :: " + encryptor().encrypt("jdbc:log4jdbc:postgresql://59.23.50.20:5432"));
        System.out.println("user :: " + encryptor().encrypt("postgres"));
        System.out.println("pass :: " + encryptor().encrypt("kyungwoo1999"));
    }

    public static StringEncryptor encryptor() {
        StandardPBEStringEncryptor enc = new StandardPBEStringEncryptor();
        enc.setPassword("smartbusiness");
        return enc;
    }

    @Bean(name = "dataSource", destroyMethod = "postDeregister")
    @Primary
    public DataSource dataSource() {
        BasicDataSource ds = new BasicDataSource();

        // ds.setDriverClassName(env.getRequiredProperty(ALIAS + ".datasource.driverClassName"));
        // ds.setUsername(encryptor().decrypt(env.getRequiredProperty(ALIAS + ".datasource.username")));
        // ds.setPassword(encryptor().decrypt(env.getRequiredProperty(ALIAS + ".datasource.password")));
        // ds.setUrl(encryptor().decrypt(env.getRequiredProperty(ALIAS + ".datasource.url")));
        ds.setDriverClassName(DRIVER_CLASS_NAME);
        ds.setUsername(encryptor().decrypt(USERNAME));
        ds.setPassword(encryptor().decrypt(PASSWORD));
        ds.setUrl(encryptor().decrypt(DB_URL) + "/" + DB_NAME);
        //ds.setValidationQuery(env.getRequiredProperty(ALIAS + ".datasourcequery.validation"));
        //connection pool에서 connection을 가져올때 해당 connection의 유효성 검사 여부
        //false가 기본값이며 true설정시 매번 validationQuery를 수행하게된다.
        ds.setTestOnBorrow(true);

        return ds;
    }

    //마이바티스 관련설정, sqlSession을 생성하기위해 factory사용
    //세션을 한번 생성하면 매핑구문을 실행하거나 커밋 또는 롤백을 하기위해 세션사용가능.
    @Bean(name = "sqlSessionFactory")
    @Primary
    public SqlSessionFactory sqlSessionFactory(@Qualifier("dataSource") DataSource dataSource, ApplicationContext applicationContext) throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        //패키지 기본경로
        sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:mapper/**/*.xml"));
        SqlSessionFactory factory = sqlSessionFactoryBean.getObject();
        assert factory != null;
        factory.getConfiguration().setMapUnderscoreToCamelCase(false);          // DTO CamelCasing 사용여부
        return factory;
    }

    //sqlSessionTemplate은 스프링 연동모듈의 핵심. sqlSession을 구현하고 코드에서 sqlSession을 대체
    //thread에 안전하고 여러개의 dao나 매퍼에서 공유가능

    @Bean(name = "sqlSessionTemplate")
    @Primary
    public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) throws Exception {
        return new SqlSessionTemplate(sqlSessionFactory);

    }
}